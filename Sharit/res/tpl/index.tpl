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
        %if clipboard%
                <h2>Clipboard</h2>
                <form action="/index.html" method="post">
                    <textarea cols="40" rows="5" name="clipboard">%clipboard%</textarea>
                    <br/>
                    <input type="submit" value="Update"/>
                </form>        
        %endif%
    </body>
</html>