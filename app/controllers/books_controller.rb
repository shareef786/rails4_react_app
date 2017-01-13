class BooksController < ApplicationController
  before_filter :find_book, :only => [:update, :destroy]

  def index
    @books = Book.all.sort_by(&:created_at)
    @booksjson = [
      {day:'02-16-2016',count:380},
      {day:'02-17-2016',count: @books.last.price},
      {day:'02-18-2016',count:150}
    ]
# binding.pry
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @booksjson }
    end
  end

  def create
    @book = Book.new(book_params)

    if @book.save
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    head :no_content
  end

  def search
    @books = Book.where("title LIKE ?", '%' + params[:title] + '%')
    render json: @books
  end

  private

  def find_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :date, :price)
  end
end
