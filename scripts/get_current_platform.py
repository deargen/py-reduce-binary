# https://stackoverflow.com/questions/51939257/how-do-you-get-the-filename-of-a-python-wheel-when-running-setup-py
from setuptools.dist import Distribution


class BinaryDistribution(Distribution):
    """Distribution which always forces a binary package with platform name."""

    def has_ext_modules(self):
        return True


def get_current_platform():
    # create a fake distribution
    dist = BinaryDistribution()
    # finalize bdist_wheel command
    bdist_wheel_cmd = dist.get_command_obj("bdist_wheel")
    bdist_wheel_cmd.ensure_finalized()
    # assemble wheel file name
    distname = bdist_wheel_cmd.wheel_dist_name
    return bdist_wheel_cmd.get_tag()[2]


print(get_current_platform())
