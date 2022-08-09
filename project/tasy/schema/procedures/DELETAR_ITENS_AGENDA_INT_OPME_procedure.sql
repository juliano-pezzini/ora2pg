-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE deletar_itens_agenda_int_opme ( nr_seq_agenda_p bigint ) AS $body$
DECLARE

 
nm_usuario_w		varchar(15);
cd_estabelecimento_w	smallint;
ie_deleta_itens_w	varchar(1);


BEGIN 
 
select	coalesce(max(a.nm_usuario_orig),''), 
	b.cd_estabelecimento 
into STRICT	nm_usuario_w, 
	cd_estabelecimento_w	 
from	agenda_paciente a, 
	agenda b 
where	a.cd_agenda = b.cd_agenda 
and 	nr_sequencia = nr_seq_agenda_p 
group by 
	b.cd_estabelecimento;
 
select	obter_dados_usuario_opcao(nm_usuario_w,'CE') 
into STRICT	cd_estabelecimento_w
;
 
ie_deleta_itens_w := obter_param_usuario(871, 511, obter_perfil_ativo, nm_usuario_w, cd_estabelecimento_w, ie_deleta_itens_w);
 
if (nr_seq_agenda_p > 0 ) and (coalesce(ie_deleta_itens_w,'N') = 'S') then 
	 
	delete from agenda_pac_opme 
	where	nr_seq_agenda = nr_seq_agenda_p 
	and	ie_integracao = 'S' 
	and	ie_integracao_util not in ('R','A');
 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE deletar_itens_agenda_int_opme ( nr_seq_agenda_p bigint ) FROM PUBLIC;
