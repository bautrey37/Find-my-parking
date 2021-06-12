import axios from "axios";

export default {
    user: { role: "", username: "" },
    login: function (context, creds, redirect) {
        axios.post("/api/sessions", creds)
            .then(response => {
                console.log("login successful");
                this.user.username = creds.username;
                //this.user.role = response.data.role; // no role field exists for user
                window.localStorage.setItem('token-'+this.user.username, response.data.token);
                console.log(window.localStorage.getItem('token-'+this.user.username));
                window.location.href = redirect
                // if (redirect)
                //  context.$router.push({path: redirect});
            })
            .catch(error => {
                console.log(error);
            });
    },
    logout: function(context, options) {
        axios.delete("/api/sessions/1", options)
            .then(response => {
                window.localStorage.removeItem('token-'+this.user.username);
                this.user.username = "";
                // this.user.role = "";
                // context.$router.push({path: '/login'});
            }).catch(error => {
            console.log(error)
        });
    },
    authenticated: function() {
        const jwt = window.localStorage.getItem('token-'+this.user.username);
        return !!jwt;
    },
    getAuthHeader: function() {
        return {
            'Authorization': 'Bearer ' + window.localStorage.getItem('token-'+this.user.username)
        }
    }
}