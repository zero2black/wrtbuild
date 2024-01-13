import telepot
import subprocess
import time
import threading
import os
import requests
import hashlib
import datetime
import random
from telepot.namedtuple import InlineKeyboardMarkup, InlineKeyboardButton, ReplyKeyboardMarkup

# Membaca token dan chat ID admin dari berkas token.txt
with open('/root/TgBotWRT/AUTH', 'r') as token_file:
    lines = token_file.readlines()
    if len(lines) >= 2:
        TOKEN = lines[0].strip()
        USER_ID = int(lines[1].strip())
    else:
        print("Berkas token harus memiliki setidaknya 2 baris (token dan chat ID admin).")
        exit()

# Daftar chat ID admin
admins = set([USER_ID])

# Lokasi file penanda (semaphore) untuk berhenti
STOP_BOT = '/root/TgBotWRT/stop.sh'

# Lokasi file cmd
CMD_FILE_PATH = '/root/TgBotWRT/cmd'

# URL untuk mengambil menu dari Folder /root
MENU_FILE_PATH = '/root/TgBotWRT/menu'

# Waktu interval untuk memeriksa perubahan cmd (dalam detik)
RELOAD_INTERVAL = 600  # Ini akan memeriksa setiap 10 menit

# Hash md5 cmd saat ini
current_cmd_file_hash = None

# Variabel global untuk waktu mulai bot
bot_start_time = None

# Daftar stiker untuk digunakan saat perintah salah
sticker_list = [
    "CAACAgUAAxkBAAEW4-xlIUDJVE25oao5Rtw0fIJ2-uOrMAAC7QkAAuBF8FQII1g3etFjfjAE",
"CAACAgUAAxkBAAEW6MxlI5SpaYOYd_DT8RoAAa3DQKcsFqEAAtgFAALOuRhWS32EkIwS8LcwBA",
]

buttons = [
    ['Some really long text I \n'
     'want on two rows :D'],
    ['Some really long text I \n'
     'want on two rows :D']
]
keyboard = ReplyKeyboardMarkup(keyboard=[['sms_4x', 'sms_s8'], ['ipremote','refresh 4x','refresh s8']])

# Set untuk melacak stiker yang sudah dikirim
sent_stickers = set()
def check_internet_ok():
    try:
        response = requests.get('https://www.google.com', timeout=10)
        return True
    except (requests.ConnectionError, requests.Timeout):
        return False


# Fungsi untuk menjalankan perintah di terminal tanpa menampilkan output
def run_command(command):
    try:
        subprocess.run(command, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return True
    except subprocess.CalledProcessError as e:
        return False

# Fungsi untuk membaca berkas teks alias
def load_aliases(file_path):
    aliases = {}
    try:
        with open(file_path, 'r') as file:
            for line in file:
                parts = line.strip().split(':')
                if len(parts) == 2:
                    alias, cmd = parts
                    aliases[alias.strip()] = cmd.strip()
    except Exception as e:
        print(f"Error loading aliases: {str(e)}")
    return aliases

# Fungsi untuk menghapus pesan setelah waktu tertentu
def delete_message_after(USER_ID, message_id, seconds):
    time.sleep(seconds)
    bot.deleteMessage((USER_ID, message_id))

# Fungsi untuk mengirim pesan menu
def send_menu(chat_id):
    with open(MENU_FILE_PATH, 'r') as menu_file:
        menu_text = menu_file.read()
        bot.sendMessage(chat_id, menu_text, reply_markup=keyboard)
#parse_mode="Markdown")

# Fungsi untuk mengirim stiker jika perintah salah
def send_random_sticker(USER_ID):
    # Pilih stiker acak yang belum pernah dikirim
    while True:
        sticker_to_send = random.choice(sticker_list)
        if sticker_to_send not in sent_stickers:
            sent_stickers.add(sticker_to_send)
            break

    bot.sendSticker(USER_ID, sticker_to_send)

# Fungsi untuk menangani perintah /menu
def handle_start(msg):
    USER_ID = msg['chat']['id']
    send_menu(USER_ID)

# Fungsi untuk menangani pesan yang diterima dari bot Telegram
def handle(msg):
    USER_ID = msg['chat']['id']
    user_id = msg['from']['id']

    # Memeriksa apakah pesan memiliki teks
    if 'text' in msg:
        command = msg['text']

        if command == '/menu':
            handle_start(msg)
        elif user_id in admins:
            if command.startswith('/cmd'):
                parts = command.split(' ', 1)
                if len(parts) == 2:
                    cmd_to_run = parts[1]
                    # Mengirim pesan "Please wait" saat perintah dikenali
                    wait_message = bot.sendMessage(USER_ID, "Please wait...1")
                    # Menjalankan perintah yang diberikan
                    if run_command(cmd_to_run):
                        # Jika perintah berhasil dijalankan, hapus pesan "Please wait..."
                        bot.deleteMessage((USER_ID, wait_message['message_id']))
                    else:
                        # Jika perintah gagal, beri pesan "Perintah salah atau gagal dijalankan."
                        send_random_sticker(USER_ID)
                        bot.sendMessage(USER_ID, "Perintah salah atau gagal dijalankan.")
                        # Hapus pesan "Perintah salah atau gagal dijalankan." setelah 5 detik
                        t = threading.Thread(target=delete_message_after, args=(USER_ID, msg['message_id'], 5))
                        t.start()
                else:
                    send_random_sticker(USER_ID)
                    bot.sendMessage(USER_ID, "The /cmd command format is incorrect.  Use: /cmd <command>")
            else:
                if command in aliases:
                    # Mengirim pesan "Please wait" saat perintah dikenali
                    wait_message = bot.sendMessage(USER_ID, "Please wait...2")
                    # Menjalankan perintah sesuai dengan alias yang ditemukan
                    if run_command(aliases[command]):
                    # Jika perintah berhasil dijalankan, hapus pesan "Please wait..."
                    # Cek koneksi internet
                        if check_internet_ok():
                            id_pesan = wait_message['message_id']
                            
                            try:
                            # Your code to delete the message
                                print('koneksiq ada...')
                                bot.deleteMessage((USER_ID, id_pesan))
                                print(f"Message {wait_message['message_id']} deleted successfully.")
                            except:
                                #time.sleep(3)
                                #print(f"Message {message_id} deleted successfully.")
                                bot.deleteMessage((USER_ID, id_pesan))
                                print(f"Message {wait_message['message_id']} gagal.")
                                #print(f"Error: {e}")
                            
                            #time.sleep(5)
                            
                        else:
                            print('disko...')
                            print 
                            bot.deleteMessage((USER_ID, wait_message['message_id']))
                            time.sleep(5)
                            bot.sendMessage(USER_ID, "koneksi hilang")
                    else:
                        # Jika perintah gagal, beri pesan "Wrong Command, Use /menu To Check"
                        send_random_sticker(USER_ID)
                        bot.sendMessage(USER_ID, "Wrong Command, Use /menu To Check")
                        # Hapus pesan "Wrong Command, Use /menu To Check" setelah 5 detik
                        t = threading.Thread(target=delete_message_after, args=(USER_ID, msg['message_id'], 5))
                        t.start()
                else:
                    # Menampilkan pesan "Wrong Command, Use /menu To Check"
                    send_random_sticker(USER_ID)
                    bot.sendMessage(USER_ID, "Wrong Command, Use /menu To Check")
        else:
            send_random_sticker(USER_ID)
            bot.sendMessage(USER_ID, "Anda bukan golongan yang diizinkan.")
    else:
        send_random_sticker(USER_ID)
        bot.sendMessage(USER_ID, "Wrong Command, Use /menu To Check")

# Fungsi untuk memeriksa koneksi internet
def check_internet_connection():
    try:
        response = requests.get('https://www.google.com', timeout=10)
        return True
    except (requests.ConnectionError, requests.Timeout):
        return False

# Fungsi untuk memuat ulang file cmd jika berubah
def reload_cmd_file():
    global current_cmd_file_hash
    new_cmd_file_hash = get_file_md5_hash(CMD_FILE_PATH)
    if new_cmd_file_hash != current_cmd_file_hash:
        current_cmd_file_hash = new_cmd_file_hash
        aliases = load_aliases(CMD_FILE_PATH)
        

# Fungsi untuk menghitung hash MD5 dari sebuah berkas
def get_file_md5_hash(file_path):
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as file:
        for chunk in iter(lambda: file.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

# Inisialisasi bot Telegram
bot = telepot.Bot(TOKEN)
bot.message_loop(handle)

# Mendapatkan daftar alias dari berkas teks
aliases = load_aliases(CMD_FILE_PATH)
current_cmd_file_hash = get_file_md5_hash(CMD_FILE_PATH)

# Set waktu mulai bot saat ini
bot_start_time = datetime.datetime.now()

print('Bot sedang berjalan. Untuk berhenti, gunakan perintah /stop')

# Biarkan bot berjalan terus selama file penanda tidak ada
while not os.path.exists(STOP_BOT):
    try:
        # Cek koneksi internet
        if check_internet_connection():
            # Tempatkan logika bot Anda di sini
            pass
        else:
            print('Tidak ada koneksi internet. Menunggu...')
            time.sleep(60)  # Menunggu 1 menit sebelum mencoba lagi
        # Cek dan muat ulang cmd jika perlu
        if time.time() % RELOAD_INTERVAL == 0:
            reload_cmd_file()
    except Exception as e:
        #print(f"Terjadi kesalahan: {str(e)}")
        # Tambahkan logika untuk menunggu sebelum mencoba lagi
        time.sleep(60)  # Menunggu 1 menit sebelum mencoba lagi

# Bot berhenti jika file penanda ada
print('Bot berhenti.')