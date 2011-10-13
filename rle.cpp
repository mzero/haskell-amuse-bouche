#include <list>
#include <utility>
using namespace std;


template<typename T>
list<pair<T,int> > runLengthEncode(const list<T>& as) {
    list<pair<T, int> > runs;
    if (!as.empty()) {
        typename list<T>::const_iterator it = as.begin();
        T elem = *it;
        int count = 0;
        
        for (; it != as.end(); it++) {
            if (elem != *it) {
                runs.push_back(make_pair(elem, count));
                elem = *it;
                count = 0;
            }
            count += 1;
        }
        runs.push_back(make_pair(elem, count));
    }
    return runs;
}
