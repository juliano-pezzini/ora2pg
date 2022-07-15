-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_internacao_manual ( nr_atendimento_p bigint, nm_usuario_p text, nr_seq_evento_p bigint ) AS $body$
DECLARE

 
nr_seq_evento_w		bigint;
cd_estabelecimento_w	smallint;
cd_pessoa_fisica_w	varchar(10);


BEGIN 
 
select	cd_pessoa_fisica, 
	cd_estabelecimento 
into STRICT	cd_pessoa_fisica_w, 
	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento	= nr_atendimento_p;
 
 
CALL gerar_evento_paciente(nr_seq_evento_p,nr_atendimento_p,cd_pessoa_fisica_w,null,nm_usuario_p,null);
 
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_internacao_manual ( nr_atendimento_p bigint, nm_usuario_p text, nr_seq_evento_p bigint ) FROM PUBLIC;

