# -*- coding: utf-8 -*-
class EntriesController < ApplicationController
  before_filter :set_user, :set_blog, :only => [ :index, :show, :create, :new, :edit, :update, :destroy ]

  before_filter :set_titles
  
  # GET /entries
  # GET /entries.xml
  def index
#    @entries = Entry.paginate :conditions => { :blog_id => @blog.id }, :page => params[:page], :order => 'created_at DESC'
    @entries = Entry.page params
    if @blog
      @auto_discovery_url = blog_entries_path(@blog.id, :atom) 
    elsif params[:tag]
      @auto_discovery_url = tag_path( params[:tag], :atom )
    end

    respond_to do |format|
      format.html # index.html.erb
      format.atom # index.html.erb
      format.xml  { render :xml => @entries }
    end
  end

  def full
    @entries = Entry.paginate :page => params[:page], :order => 'created_at DESC'
    respond_to do |format|
      format.atom # index.html.erb
    end
  end

  # GET /entries/1
  # GET /entries/1.xml
  def show
    @entry = Entry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @entry }
    end
  end

  # GET /entries/new
  # GET /entries/new.xml
  def new
#    @blog = Blog.find( params[:blog_id] )
    @entry = Entry.new(:author => @user, :blog_id => @blog.id, :title => "#{h(@user).capitalize}s PPP am #{ Date.today}")

    respond_to do |format|
      format.html { render :action => 'edit'}
      format.xml  { render :xml => @entry }
    end
  end

  # GET /entries/1/edit
  def edit
    @entry = Entry.find(params[:id])
  end

  # POST /entries
  # POST /entries.xml
  def create
#    @blog = Blog.find( params[:blog_id] )
    
    @entry = Entry.new(params[:entry])
    @entry.author = @user
    @entry.blog_id = @blog.id
    respond_to do |format|
      if @entry.save
        flash[:notice] = 'Entry was successfully created.'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @entry, :status => :created, :location => @entry }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /entries/1
  # PUT /entries/1.xml
  def update
    @entry = Entry.find(params[:id])

    respond_to do |format|
      if @entry.update_attributes(params[:entry])
        flash[:notice] = 'Entry was successfully updated.'
        format.html { redirect_to :action => 'index' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.xml
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to(entries_url) }
      format.xml  { head :ok }
    end
  end                  
   
  def home
    redirect_to :action => 'user_home', :id => @user
  end
  
  def user_home
    @author = params[:author]
    @entries = Entry.paginate :conditions => { :author => params[:author] }, :page => params[:page], :order => 'created_at DESC'
    @auto_discovery_url = user_home_path(@author, :atom)

    
    respond_to do |format|
      format.html { render :action => 'index' }
      format.atom { render :action => 'index' }
      format.xml  { render :xml => @entries }
    end
    
  end
  
  private
    def set_blog
      blog_id = params[:blog_id]
      @blog = Blog.find( blog_id ) unless blog_id.nil?
    end

  private
    def set_titles
      @titles = {
        :progress => 'Folgendes habe ich gestern/heute erreicht:',
        :plans => 'Ich plane heute/morgen zu tun:',
        :no_plans => 'Aktuell habe ich keine Pläne mitzuteilen.',
        :problems => 'Ich habe folgende Probleme, die ich ohne Hilfe nicht lösen kann:',
        :no_problems => 'Aktuell habe ich alle Probleme im Griff.'
      }
    end

end
