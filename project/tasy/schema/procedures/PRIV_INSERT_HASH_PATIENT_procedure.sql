-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE priv_insert_hash_patient (nm_usuario_p text, cd_pessoa_fisica_p text, cd_hash_cliente_p text) AS $body$
DECLARE



nr_sequencia_w	bigint;


BEGIN

	select	coalesce(max(nr_sequencia), 0)
	into STRICT	nr_sequencia_w
	from	priv_controle_lib_exc_pf
	where	cd_hash_cliente	= cd_hash_cliente_p and cd_pessoa_fisica = cd_pessoa_fisica_p;


  if (nr_sequencia_w = 0) then
	begin
      		insert          into priv_controle_lib_exc_pf( nr_Sequencia,
                 			nm_usuario,
		                        dt_atualizacao,
                       			cd_pessoa_fisica,
		                        cd_hash_cliente,
                       			dt_geracao_hash
                       		        ) VALUES (
		                        nextval('priv_controle_lib_exc_pf_seq'),
                       			nm_usuario_p,
		                        clock_timestamp(),
                       			cd_pessoa_fisica_p,
		                        cd_hash_cliente_p,
                       			clock_timestamp());

	end;
  else
	begin
    		update              priv_controle_lib_exc_pf
    		set                 dt_atualizacao      =   clock_timestamp(),
                        	    dt_geracao_hash  =  clock_timestamp()
   		where               nr_sequencia   =    nr_sequencia_w;
	end;

  end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE priv_insert_hash_patient (nm_usuario_p text, cd_pessoa_fisica_p text, cd_hash_cliente_p text) FROM PUBLIC;

