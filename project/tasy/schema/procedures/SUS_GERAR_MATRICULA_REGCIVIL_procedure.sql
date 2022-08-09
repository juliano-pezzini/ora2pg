-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_matricula_regcivil (nr_seq_regcivil_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_matricula_rn_w		varchar(32);
dt_emissao_rn_w			timestamp;
nr_atendimento_w		bigint;
nr_folha_w			varchar(4);
nr_livro_w			varchar(8);
nr_termo_w			varchar(8);
cd_estabelecimento_w		smallint;
cd_acervo_w			varchar(15);
nr_nac_serventia_w		bigint;
nr_tipo_livro_w			integer;
					

BEGIN 
 
begin 
select	dt_emissao_rn, 
	nr_atendimento, 
	nr_folha, 
	nr_livro, 
	nr_termo 
into STRICT	dt_emissao_rn_w, 
	nr_atendimento_w, 
	nr_folha_w, 
    nr_livro_w, 
    nr_termo_w 
from	sus_registro_civil 
where	nr_sequencia = nr_seq_regcivil_p;
exception 
when others then 
	--R.aise_application_error(-20011,'Problemas ao ler as informações do registro civil.'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263460);
end;
 
begin 
select 	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	atendimento_paciente 
where	nr_atendimento = nr_atendimento_w;
exception 
when others then 
	--R.aise_application_error(-20011,'Problemas ao obtero o estabelecimento do atendimento.'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263461);
end;
 
begin 
select	cd_acervo, 
	nr_nac_serventia, 
	nr_tipo_livro 
into STRICT	cd_acervo_w, 
	nr_nac_serventia_w, 
	nr_tipo_livro_w 
from	sus_parametros_aih 
where	cd_estabelecimento = cd_estabelecimento_w;
exception 
when others then 
	--R.aise_application_error(-20011,'Problemas ao obter as informações dos parametros da AIH.'); 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263518);
end;
 
nr_matricula_rn_w := 	lpad(substr(nr_nac_serventia_w,1,6),6,'0')||substr(cd_acervo_w,1,2)||'55'||to_char(dt_emissao_rn_w,'yyyy')|| 
			substr(nr_tipo_livro_w,1,1)||lpad(substr(nr_livro_w,1,5),5,'0')||lpad(substr(nr_folha_w,1,3),3,'0')||lpad(substr(nr_termo_w,1,7),7,'0');
			 
nr_matricula_rn_w :=	nr_matricula_rn_w||Calcula_Digito('MODULO11',nr_matricula_rn_w);
nr_matricula_rn_w :=	nr_matricula_rn_w||Calcula_Digito('MODULO11',nr_matricula_rn_w);
			 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_matricula_regcivil (nr_seq_regcivil_p bigint, nm_usuario_p text) FROM PUBLIC;
