var gulp = require('gulp');
var shell = require('gulp-shell');
var browserSync = require('browser-sync').create();

// Build something
gulp.task('build', shell.task(['bundle exec jekyll build --limit_posts=10']));

// Task for building blog when something changed:
gulp.task('build-watch', shell.task(['bundle exec jekyll build --limit_posts=10 --watch --incremental']));

// Build everything
gulp.task('build-production', shell.task(['bundle exec jekyll build']));

// Task for serving blog with Browsersync
gulp.task('serve', function () {
    browserSync.init({
        server: {
            baseDir: '_site/'
        },
        port: 4000,
        open: false,
        notify: false
    });
    var reload = debounce(browserSync.reload, 1000);
    // Reloads page when some of the already built files changed:
    gulp.watch(['_site/**/*.html', '_site/**/*.css']).on('change', reload);
});

gulp.task('default', ['build-watch', 'serve']);

function debounce(func, wait, immediate) {
    var timeout;
    return function() {
        var context = this, args = arguments;
        var later = function() {
            timeout = null;
            if (!immediate) func.apply(context, args);
        };
        var callNow = immediate && !timeout;
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
        if (callNow) func.apply(context, args);
    };
}
