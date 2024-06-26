import os
import requests
from bs4 import BeautifulSoup
from telegraph import Telegraph
import telebot

# Initialize Telegraph API
telegraph = Telegraph()
telegraph.create_account(short_name='Test')

# Initialize Telegram Bot API
API_TOKEN = '7490938141:AAHJCgj4cGrBS7muH9GvKknrhcorLiOk39Y'
bot = telebot.TeleBot(API_TOKEN)

# Download and upload image function
def download_image(image_url, filename):
    response = requests.get(image_url)
    with open(filename, 'wb') as f:
        f.write(response.content)

# Command to start the bot
@bot.message_handler(commands=['start', 'help'])
def send_welcome(message):
    bot.reply_to(message, "Send me the URL to start downloading and uploading images.")

# Command to process the URL
@bot.message_handler(func=lambda message: True)
def handle_message(message):
    url = message.text

    # Inform the user that the process has started
    bot.reply_to(message, "Downloading and uploading images, please wait...")

    response = requests.get(url)

    if response.status_code == 200:
        
        soup = BeautifulSoup(response.content, 'html.parser')

        image_links = [img['src'] for img in soup.select('p img[decoding="async"]')]

        uploaded_images = []
        
        for link in image_links:
            # Download the image
            image_name = link.split("/")[-1]
            download_image(link, image_name)
            
            # Upload the image to Telegraph
            with open(image_name, 'rb') as f:
                response = telegraph.upload_file(f)
            
            # Get the URL of the uploaded image
            telegraph_image_url = 'https://telegra.ph' + response[0]['src']
            uploaded_images.append(telegraph_image_url)
            
            # Optionally, delete the downloaded image file to save space
            os.remove(image_name)
        
        # Create Telegraph page with all uploaded images
        content = ''.join([f'<img src="{url}"/>' for url in uploaded_images])
        response = telegraph.create_page(
            title='All Images',
            author_name='Test',
            html_content=content
        )

        telegraph_page_url = f"https://telegra.ph/{response['path']}"
        bot.reply_to(message, f"Telegraph page URL: {telegraph_page_url}")
    else:
        bot.reply_to(message, "Failed to retrieve the URL. Please check the URL and try again.")

# Polling for bot messages
bot.polling()
