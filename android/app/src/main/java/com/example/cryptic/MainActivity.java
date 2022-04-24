package com.example.cryptic;

import android.annotation.SuppressLint;
import android.os.Build;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.cryptic/native";
    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler((call, result) -> {
            if(call.method.equals("encrypt")) {
                byte[] fetchedList = call.argument("data");
                final String SecretKey = new String((byte[]) call.argument("pwd"));
                //final String SecretKey = "123";

                byte[] encrypt1 = partOne.encrypt(fetchedList, SecretKey);
                byte[] encrypt2 = partTwo.encrypt(encrypt1, SecretKey);

                result.success(encrypt2);
            } else if(call.method.equals("decrypt")) {
                byte[] fetchedList = call.argument("data");
                final String SecretKey = new String((byte[]) call.argument("pwd"));
                //final String SecretKey = "123";

                byte[] decrypt1 = partTwo.decrypt(fetchedList, SecretKey);
                byte[] decrypt2 = partOne.decrypt(decrypt1, SecretKey);

                result.success(decrypt2);
            }
        });
    }
}

class partOne{
    @RequiresApi(api = Build.VERSION_CODES.O)
    public static byte[] encrypt(byte[] dataToEncrypt, String key) {
        try {
            byte[] keyData = (key).getBytes();
            SecretKeySpec secretKeySpec = new SecretKeySpec(keyData, "Blowfish");
            Cipher cipher = Cipher.getInstance("Blowfish");
            cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
            return Base64.getEncoder().encode(dataToEncrypt);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public static byte[] decrypt(byte[] dataToDecrypt, String key) {
        try {
            byte[] keyData = (key).getBytes();
            SecretKeySpec secretKeySpec = new SecretKeySpec(keyData, "Blowfish");
            Cipher cipher = Cipher.getInstance("Blowfish");
            cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
            return Base64.getDecoder().decode(dataToDecrypt);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}

class partTwo {
    private static SecretKeySpec secretKey;

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    public static void setKey(String myKey)
    {
        MessageDigest sha;
        try {
            byte[] key = myKey.getBytes(StandardCharsets.UTF_8);
            sha = MessageDigest.getInstance("SHA-1");
            key = sha.digest(key);
            key = Arrays.copyOf(key, 16);
            secretKey = new SecretKeySpec(key, "AES");
        }
        catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
    }


    @RequiresApi(api = Build.VERSION_CODES.O)
    public static byte[] encrypt(byte[] dataToEncrypt, String key) {
        try {
            setKey(key);
            @SuppressLint("GetInstance") Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            return Base64.getEncoder().encode(dataToEncrypt);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public static byte[] decrypt(byte[] dataToDecrypt, String key) {
        try {
            setKey(key);
            @SuppressLint("GetInstance") Cipher cipher = Cipher.getInstance("AES");
            cipher.init(Cipher.DECRYPT_MODE, secretKey);
            return Base64.getDecoder().decode(dataToDecrypt);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
