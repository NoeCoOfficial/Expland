# ============================================================= #
# EncryptionManager.gd [AUTOLOAD]
# ============================================================= #
#                       COPYRIGHT NOTICE                        #
#                           Noe Co.                             #
#            (2024 - Present) - All Rights Reserved             #
#                                                               #
#                     Noe Co. Game License                      #
#                                                               #
# Permission is hereby granted to any person to view, fork,     #
# and make personal modifications to this software (the         #
# "Software"), solely for private, non-commercial use.          #
#                                                               #
# Restrictions:                                                 #
# 1. You may NOT distribute, publish, or make publicly          #
#    available any part of the original or modified Software.   #
# 2. You may NOT share, host, or release modified versions,     #
#    including derivative works, in any public or commercial    #
#    form.                                                      #
# 3. You may NOT use the Software for commercial purposes       #
#    without prior written permission from Noe Co.              #
#                                                               #
# Ownership:                                                    #
# Noe Co. retains all rights, title, and interest in and to     #
# the Software and associated intellectual property. This       #
# license does not grant ownership of the Software.             #
#                                                               #
# Termination:                                                  #
# This license is effective as of your initial access and       #
# remains until terminated. Breach of any term results in       #
# automatic termination, requiring destruction of all copies.   #
#                                                               #
# Disclaimer of Warranty:                                       #
# THE SOFTWARE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY      #
# KIND. NOE CO. DISCLAIMS ALL WARRANTIES, WHETHER EXPRESS,      #
# IMPLIED, OR STATUTORY, INCLUDING WARRANTIES OF                #
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.          #
#                                                               #
# Limitation of Liability:                                      #
# NOE CO. SHALL NOT BE LIABLE FOR ANY DAMAGES ARISING FROM      #
# USE OR INABILITY TO USE THE SOFTWARE, INCLUDING INDIRECT,     #
# INCIDENTAL, OR CONSEQUENTIAL DAMAGES.                         #
#                                                               #
#                   For inquiries, contact:                     #
#                  noeco.official@gmail.com                     #
# ============================================================= #

extends Node

# AES encryption with ECB mode and padding
func encrypt_data(data: Dictionary, key: String) -> PackedByteArray:
	var aes = AESContext.new()
	var key_bytes = key.to_utf8_buffer()  # Convert the key to a byte array
	var data_str = JSON.stringify(data)  # Convert dictionary to JSON string
	var data_bytes = data_str.to_utf8_buffer()  # Convert the string to a byte array

	# Add padding to the data
	var padded_data = add_padding(data_bytes)

	aes.start(AESContext.MODE_ECB_ENCRYPT, key_bytes)  # Start encryption in ECB mode
	var encrypted_data = aes.update(padded_data)  # Encrypt padded data
	aes.finish()  # Finish the encryption

	return encrypted_data  # Return encrypted data


# AES decryption with ECB mode
func decrypt_data(encrypted_data: PackedByteArray, key: String) -> Dictionary:
	var aes = AESContext.new()
	var key_bytes = key.to_utf8_buffer()  # Convert the key to a byte array
	
	aes.start(AESContext.MODE_ECB_DECRYPT, key_bytes)  # Start decryption in ECB mode
	var decrypted_data = aes.update(encrypted_data)  # Decrypt data
	aes.finish()  # Finish the decryption
	
	var decrypted_str = decrypted_data.get_string_from_utf8()  # Convert bytes to string
	
	# Create a JSON instance and parse the decrypted string into a dictionary
	var json = JSON.new()
	var parsed_result = json.parse(decrypted_str)
	
	if parsed_result == OK:
		return json.data  # Successfully parsed string into a dictionary
	else:
		print("Failed to parse JSON")
		return {}  # Return an empty dictionary if parsing fails


# Function to add PKCS7 padding
func add_padding(data: PackedByteArray) -> PackedByteArray:
	var padding_length = 16 - (data.size() % 16)  # Calculate how much padding is needed
	var padding = PackedByteArray()  # Create a PackedByteArray for padding
	for i in range(padding_length):
		padding.append(padding_length)  # Add the padding byte value (which is the length itself)

	return data + padding  # Return the original data plus the padding
