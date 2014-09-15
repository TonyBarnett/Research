__author__ = 'Tony'

class researchdb:
	__metaclass__ = researchdb

	@abstractmethod
	def read_from_db(self):
        pass
    
    @abstractmethod
    def write_to_db(self):
        pass