import sys
from tempfile import TemporaryDirectory

from debler.app import AppInfo, AppBuilder
from debler.builder import publish, BuildFailError
from debler.db import Database


def run(args):
    db = Database()
    app = AppInfo.fromyml(db, args.app_info)

    app.schedule_dep_builds()
    if args.schedule_dep_builds_only:
        return

    with TemporaryDirectory() as d:
        builder = AppBuilder(db, d, app)
        builder.generate()
        try:
            builder.build()
        except BuildFailError:
            sys.exit(5)

    publish('app')


def register(subparsers):
    parser = subparsers.add_parser('pkgapp')
    parser.add_argument('app_info',
                        help='file to app info yml description file')
    parser.add_argument('--schedule-dep-builds-only', '-D',
                        action='store_true', default=False,
                        help='only schedule needed builds for depended gems')
    parser.set_defaults(run=run)
