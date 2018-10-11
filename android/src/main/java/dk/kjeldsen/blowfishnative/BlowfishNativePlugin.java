package dk.kjeldsen.blowfishnative;

import android.util.Base64;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.util.List;

/** BlowfishNativePlugin */
public class BlowfishNativePlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "blowfish_native");
    channel.setMethodCallHandler(new BlowfishNativePlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    List<Object> arguments = call.arguments();
    if (call.method.equals("encrypt")) {
      try {
        result.success(encrypt((String)arguments.get(0), (String)arguments.get(1)));
      } catch (Exception e) {
        result.success("");
      }
    } else {
      result.notImplemented();
    }
  }

  private String encrypt(String key, String password) throws Exception {
    byte[] KeyData = key.getBytes();
    SecretKeySpec KS = new SecretKeySpec(KeyData, "Blowfish");
    Cipher cipher = Cipher.getInstance("Blowfish/ECB/PKCS5Padding");
    cipher.init(Cipher.ENCRYPT_MODE, KS);
    return Base64.encodeToString(cipher.doFinal(password.getBytes()), Base64.NO_CLOSE);
  }

}
