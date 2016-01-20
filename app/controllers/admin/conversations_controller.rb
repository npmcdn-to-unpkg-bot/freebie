class Admin::ConversationsController < AdminController

  before_action :get_mailbox
  before_action :get_conversation, except: [:index, :empty_trash]
  before_action :get_conversations, only: [:index, :show]

  def index

  end

  def show
    @conversation.mark_as_read(current_user)
  end

  def reply
    current_user.reply_to_conversation(@conversation, params[:body])
    flash[:success] = 'Reply sent'
    redirect_to admin_conversation_path(@conversation)
  end

  def destroy
    @conversation.move_to_trash(current_user)
    flash[:success] = 'The conversation was moved to trash.'
    redirect_to admin_conversations_path
  end

  def restore
    @conversation.untrash(current_user)
    flash[:success] = 'The conversation was restored.'
    redirect_to admin_conversations_path
  end

  def empty_trash
    @mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(deleted: true)
    end
    flash[:success] = 'Your trash was cleaned!'
    redirect_to admin_conversations_path
  end

  private

  def get_mailbox
    @mailbox ||= current_user.mailbox
  end

  def get_conversation
    @conversation ||= @mailbox.conversations.find(params[:id])
  end

  def get_box
    if params[:box].blank? or !["inbox","sent","trash"].include?(params[:box])
      params[:box] = 'inbox'
    end
    params[:box]
  end

  def get_conversations
    @box = get_box

    if @box.eql? "inbox"
      mailbox = @mailbox.inbox
    elsif @box.eql? "sent"
      mailbox = @mailbox.sentbox
    else
      mailbox = @mailbox.trash
    end

    @conversations = mailbox.paginate(page: params[:page], per_page: 10)
  end

end
