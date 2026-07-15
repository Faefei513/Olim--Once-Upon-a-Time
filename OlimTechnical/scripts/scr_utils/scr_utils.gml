function approach(_current, _target, _amount) {
    if (_current < _target) return min(_current + _amount, _target);
    else return max(_current - _amount, _target);
}
