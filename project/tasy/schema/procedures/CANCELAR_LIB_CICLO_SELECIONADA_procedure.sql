-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cancelar_lib_ciclo_selecionada ( nr_seq_paciente_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w	 	bigint;
cd_pessoa_fisica_w 	varchar(10);
nr_atendimento_w	bigint;


BEGIN 
 
update	paciente_setor_lib 
set		dt_cancelamento	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p 
where	nr_sequencia	= nr_sequencia_p 
and		coalesce(dt_cancelamento::text, '') = '';
 
commit;
 
select 	max(cd_pessoa_fisica) 
into STRICT	cd_pessoa_fisica_w 
from	paciente_setor 
where	nr_seq_paciente = nr_seq_paciente_p;
 
select	max(nr_atendimento) 
into STRICT	nr_atendimento_w 
from	atendimento_paciente 
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
 
CALL gerar_evento_lib_ciclo(nr_atendimento_w, cd_pessoa_fisica_w, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, nr_seq_paciente_p, 'C');
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cancelar_lib_ciclo_selecionada ( nr_seq_paciente_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

