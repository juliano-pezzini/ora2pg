-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eis_inserir_protocolo_doc_item ( nr_interno_conta_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_item_w		integer;
cd_convenio_w		integer;
cd_pessoa_fisica_w	varchar(10);
cd_setor_atendimento_w	integer;
nr_atendimento_w		bigint;


BEGIN

begin
select	max(cd_convenio),
	max(cd_pessoa_fisica),
	max(cd_setor_atendimento),
	max(nr_atendimento)
into STRICT	cd_convenio_w,
	cd_pessoa_fisica_w,
	cd_setor_atendimento_w,
	nr_atendimento_w
from	w_eis_conta_pendente
where	nr_interno_conta = nr_interno_conta_p;
exception
when no_data_found then
select	max(cd_convenio),
	max(cd_pessoa_fisica),
	max(cd_setor_atendimento),
	max(nr_atendimento)
into STRICT	cd_convenio_w,
	cd_pessoa_fisica_w,
	cd_setor_atendimento_w,
	nr_atendimento_w
from	w_eis_conta_pend_rel_novo
where	nr_interno_conta = nr_interno_conta_p;
when others then
	cd_convenio_w 		:= null;
	cd_pessoa_fisica_w	:= '';
	cd_setor_atendimento_w	:= null;
	nr_atendimento_w		:= null;
end;

select	coalesce(max(nr_seq_item),0) +1
into STRICT	nr_seq_item_w
from 	protocolo_doc_item
where 	nr_sequencia = nr_sequencia_p;

insert into protocolo_doc_item(	nr_sequencia,  
 			        	nr_seq_interno,
				nr_seq_item,
				cd_convenio,
				cd_pessoa_fisica,
				cd_setor_atendimento,
				nr_documento,
				dt_inclusao_item,				
				nm_usuario,
				dt_atualizacao
			       )
values (	nr_sequencia_p,
				nr_interno_conta_p,
				coalesce(nr_seq_item_w,0),
				cd_convenio_w,
				cd_pessoa_fisica_w,
				cd_setor_atendimento_w,
				nr_atendimento_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp()
			       );	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eis_inserir_protocolo_doc_item ( nr_interno_conta_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
