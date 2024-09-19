import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class S3Bucket {
  static Future<void> uploadImage(File imagePath, String koiType,
      String priceRange, String? userEmail, String currentDateTime) async {
    // Gateway URL
    String url =
        'YOUR-AWS-API';

    final bytes = await imagePath.readAsBytes();
    final String base64Image = base64Encode(bytes);

    // Set up POST request arguments

    Map<String, String> headers = {"Content-type": "application/json"};
    String json1 = jsonEncode({
      'image_base64': base64Image,
      'koi_type': koiType,
      'price_range': priceRange,
      'user_email': userEmail,
      'current_datetime': currentDateTime
    });

    // Make async POST request
    var response =
        await http.post(Uri.parse(url), headers: headers, body: json1);

    if (response.statusCode == 200) {
      print('Successfully uploaded image.');
    } else if (response.statusCode == 400) {
      print(response.body.toString());
    } else {
      print('Failed to upload image.');
    }
  }

  static Future<List<dynamic>> getImageUrlsFromLambda(String? userEmail) async {
    String lambdaUrl =
        'YOUR-AWS-API';

    Map<String, String> headers = {"Content-type": "application/json"};
    String body = jsonEncode({'user_email': userEmail});

    try {
      var response =
          await http.post(Uri.parse(lambdaUrl), headers: headers, body: body);
      print(response.body);

      if (response.statusCode == 200) {
        // Parse response body
        final List<dynamic> data = json.decode(response.body);
        return data;
      } else if (response.statusCode == 404) {
        // If the server did not return a 200 OK response,
        // throw an exception with the error message received from the server.
        return [];
      } else {
        throw Exception(
            'Failed to fetch image URLs with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Print detailed error message
      print('Error fetching image URLs: $e');
      // Re-throw the exception to propagate it to the caller
      rethrow;
    }
  }

  static Future<void> deleteImageFromS3Bucket(
      String filename, String? userEmail) async {
        
    print('Attempting to delete file: $filename');
    String lambdaUrl =
        'YOUR-AWS-API';

    try {
      // Prepare headers for JSON content type
      var headers = {'Content-Type': 'application/json'};
      // Encode the filename into JSON for the request body
      var body = jsonEncode({'filename': filename, 'user_email': userEmail});

      // Make a DELETE request to the Lambda function
      final response =
          await http.delete(Uri.parse(lambdaUrl), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Delete successful: ${response.body}');
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception(
            'Failed to delete image. Status Code: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      // Log and re-throw the exception to be handled by the caller
      print('Error deleting image: $e');
      rethrow;
    }
  }

  static Future <void> deleteDialog(context, deleteFunction) async {
    showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text('Are you sure you want to delete?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Close the dialog without doing anything
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    // Perform the delete action and close the dialog
                    Navigator.of(context).pop();
                    // Add your delete logic here
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
  }
}
