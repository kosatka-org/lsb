<?php
	require_once "database_helper.php";

	set_include_path( $_SERVER['DOCUMENT_ROOT'] . '/third_party' . PATH_SEPARATOR .  get_include_path() );

    include_once 'Zend/Mail.php';
    require_once 'Zend/Mail/Transport/Smtp.php';



    class email_template extends database_helper
    {

        protected $_variables;

        protected $_mailer = false;
        static protected $_mailTransport;

        /**
         * Class constructor init email_template by alias
         *
         */
        public function __construct( $id = 0, $data = NULL )
        {
            $this->_variables = array();

			database_helper::database_helper(NULL, 'emails');
			$this->table 	= 'emails';
			$this->id_name 	= 'id';

			if (!empty($data)) {
				$this->data = $data;
			}
			elseif ( !empty($id) ) {
				$this->load_data($id);
			}

			$s = $this->db->result("SELECT * FROM emails_senders WHERE id = {$this->data->smtp}");
			if ( $s ) { // Значит нужен smtp сервер-сендер
				$this->set_smtp_transport( $s->login, $s->password, $s->hostname );
			}
        }


		/**
		 *
		 */
		static public function set_smtp_transport( $username, $password, $server ) {
			$config = array('auth'     => 'login',
							'username' => $username,
							'password' => $password,
							'server'   => $server,
							'ssl' 	   => 'tls',
							'port' 	   => 25);
			$transport = new Zend_Mail_Transport_Smtp($config['server'], $config);
			Zend_Mail::setDefaultTransport($transport);
		}



		public function load_data($id)
		{
			if ( empty($id) ) {
				return $this->data = false;
			}
			$id = $this->db->escape( $id );
			return $this->data = $this->db->get_row("SELECT * FROM {$this->table} WHERE {$this->id_name} = '{$id}' OR alias = '{$id}'");
		}



        /**
         * Assign a value to template variable
         *
         * @param string $key - variable name
         * @param string $value - value to assign
         *
         * @return knexus_email_templates
         *
         */
        public function assign($key, $value)
        {
            $key = '{' . $key . '}';

            $this->_variables[$key] = $value;

            return $this;
        }



        /**
         * Send an email
         *
         * @param string $recipientEmail - email of a recipient
         * @param string $recipientName - name of a recipient
         * @return bool
         */
        public function send($recipientEmail, $recipientName='', &$result = true)
        {
			if ( empty($recipientEmail) ) return $this;

            if (!is_object($this->_mailer)) {
                $this->_mailer = new Zend_Mail('UTF-8');
                $this->_mailer->setFrom( 'mail@lsboutique.ru', 'Лакшери Стор' );
            }

            $this->_mailer->clearSubject();
            $this->_mailer->clearRecipients();
            $this->_mailer->addTo($recipientEmail, $recipientName);

            // set subject
            $subject = $this->getMergedField( 'subject' );
            $this->_mailer->setSubject($subject);

            // set html body (if exists)
            $bodyHtml = $this->getMergedField( 'body_html' );
            if ( !strlen($bodyHtml) ) {
                $bodyHtml = nl2br($this->getMergedField( 'body_text' ));
            }
            if (strlen($bodyHtml)) {
                $this->_mailer->setBodyHtml( $bodyHtml );
            }

            // set text body (if exists)
            $bodyText = $this->getMergedField( 'body_text' );
            if ( !strlen($bodyText) ) {
                $bodyText = strip_tags( $this->getMergedField('body_html') );
            }
            if (strlen($bodyText)) {
                $this->_mailer->setBodyText( $bodyText );
            }

            try {
                $this->_mailer->send();
                $result = true;
                $send_status = 'Email sent';
            } catch (Zend_Mail_Exception $exception) {
                $result = false;
                $send_status = $exception->getMessage();
				mail('shesternin@gmail.com,izvekovvadim@gmail.com', $_SERVER['SERVER_NAME'] . ' - EMAIL SEND ERROR', "Email address: {$recipientEmail}<br>Email send status: {$send_status}");
            }

            return $this;
        } // end public function send()



        /**
         * Get merged body in HTML code format
         *
         * @return string
         */
        public function getMergedField($field = '')
        {
            $value = $this->get($field);
            if (strlen($value)) {

                $vars = array_keys($this->_variables);
                $vals = array_values($this->_variables);

                return str_replace($vars, $vals, $value);
            }
            return '';
        }



        /**
         * Get merged body in HTML code format
         *
         * @return string
         */
        public function getMergedBodyHtml()
        {
            return $this->getMergedField( 'body_html' );
        }
    }
