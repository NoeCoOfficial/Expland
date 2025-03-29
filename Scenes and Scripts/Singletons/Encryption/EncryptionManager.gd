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
