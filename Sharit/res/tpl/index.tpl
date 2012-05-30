<!doctype html>
<html>
    <head>
        <link rel="icon" type="image/png" href="/favicon.png">
        <link rel="apple-touch-icon" type="image/png" href="/apple-touch-favicon.png">
        <title>SharIt</title>
    </head>
    <body>
        <h1>SharIt</h1>
        <p>Share your stuff</p>
        %if clipboard_is_shared%
                <h2>Pasteboard</h2>
                <h3>Text:</h3>
                <form action="/index.html" method="post">
                    <textarea cols="40" rows="5" name="clipboard">%clipboard_text%</textarea>
                    <br/>
                    <input type="submit" value="Update"/>
                </form>
                %if clipboard_image%
                <h3>Image:</h3>
                <a href="%clipboard_image_src%">
                <img src="%clipboard_thumb_image_src%" width="%clipboard_thumb_image_width%" height="%clipboard_thumb_image_height%" />
                </a>
                %endif%
        %endif%
    </body>
</html>