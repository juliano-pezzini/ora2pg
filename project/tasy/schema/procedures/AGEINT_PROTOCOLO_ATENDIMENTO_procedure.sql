-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_protocolo_atendimento (cd_pessoa_fisica_p text, nm_usuario_p text, cd_protocolo_p text, ie_opcao_p text, ds_protocolo_p INOUT text) AS $body$
DECLARE


 /* O = Obter protocolo
    F = Finalizar protocolo 
    I = Inserir protocolo integracao */
 														 
 
 
BEGIN 
	 
	IF (ie_opcao_p = 'O') then

	select max(cd_protocolo)
	into STRICT  ds_protocolo_p
 	from  ageint_protocolo_atend 
 	where nm_usuario = nm_usuario_p
 	AND (cd_pessoa_fisica = cd_pessoa_fisica_p
 	OR    coalesce(cd_pessoa_fisica::text, '') = '')
 	and   coalesce(dt_fim_atend::text, '') = '';

	ELSIF (ie_opcao_p = 'F') THEN
	
	update ageint_protocolo_atend 
	 	set dt_fim_atend = clock_timestamp() 
	 where cd_protocolo = cd_protocolo_p
	 or (nm_usuario = nm_usuario_p
	 and coalesce(dt_fim_atend::text, '') = '');

	ELSIF (ie_opcao_p = 'I') THEN
	
	INSERT INTO ageint_protocolo_atend(nr_sequencia,
									   dt_inicio_atend, 
									   dt_atualizacao, 
									   nm_usuario, 
									   cd_protocolo, 
									   cd_pessoa_fisica)
									   values (nextval('ageint_protocolo_atend_seq'),
									   clock_timestamp(),
									   clock_timestamp(),
									   nm_usuario_p,
									   cd_protocolo_p,
									   cd_pessoa_fisica_p);
	ds_protocolo_p := cd_protocolo_p;
	END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_protocolo_atendimento (cd_pessoa_fisica_p text, nm_usuario_p text, cd_protocolo_p text, ie_opcao_p text, ds_protocolo_p INOUT text) FROM PUBLIC;

