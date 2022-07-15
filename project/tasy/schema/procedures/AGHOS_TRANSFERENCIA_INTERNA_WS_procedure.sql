-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aghos_transferencia_interna_ws ( nr_atendimento_p bigint, nr_seq_unid_destino_p bigint, nm_usuario_p text, ie_sincrona_p text default 'N', idf_internacao_p INOUT bigint DEFAULT NULL, cod_posto_enfermagem_p INOUT text DEFAULT NULL, cod_enfermaria_p INOUT text DEFAULT NULL, cod_leito_p INOUT text DEFAULT NULL, cod_digito_leito_p INOUT text DEFAULT NULL, des_usuario_p INOUT text  DEFAULT NULL) AS $body$
DECLARE

 
cd_setor_atendimento_w		bigint;
ds_motivo_cancelamento_w	varchar(1000);
cd_cnes_solicitante_w		varchar(1000);
ds_sep_bv_w			varchar(50);
ds_comando_w			varchar(2000);
cd_setor_destino_w		bigint;
nm_setor_integracao_w		varchar(255);
nr_internacao_w			bigint;
cd_enfermaria_w			varchar(3);
cd_leito_w			varchar(10);
cd_dig_leito_w			varchar(1);
ds_usuario_w			varchar(15);
nr_seq_unidade_w		bigint;
cd_pessoa_fisica_w		varchar(10);

BEGIN
 
/*  
IDF_GSH_I_INTERN_TRAINT_ENT 	NUMBER 		not null 
TIP_STATUS 			VARCHAR2 1 	not null 
DES_ERRO 			VARCHAR2 500 	null 
DAT_INTEGRACAO 		DATE 		not null 
DES_USUARIO 			VARCHAR2 15 	not null 
COD_CNES_SOLICITANTE 		NUMBER 7 	not null 
IDF_INTERNACAO 		NUMBER 9 	not null 
COD_POSTO_ENFERMAGEM 		NUMBER 3 	not null 
COD_ENFERMARIA			NUMBER 3 	not null 
COD_LEITO			NUMBER 10 	not null 
COD_DIGITO_LEITO 		VARCHAR2 1 	null 
DES_LAUDO 			VARCHAR2 1000 	null 
IDF_TRANSFERENCIA_ESTADO 	NUMBER 1 	not null 
*/
 
 
select	max(substr(obter_cnes_estab(b.cd_estabelecimento), 1, 7)), 
	max(a.nr_internacao), 
	coalesce(max(substr(obter_dados_param_atend(b.cd_estabelecimento, 'US'), 1, 15)), 'TREINA'), 
	max(nr_seq_unidade) 
into STRICT	cd_cnes_solicitante_w, 
	nr_internacao_w, 
	ds_usuario_w, 
	nr_seq_unidade_w 
from	solicitacao_tasy_aghos a, 
	atendimento_paciente b 
where	a.nr_atendimento = nr_atendimento_p 
and	b.nr_atendimento = a.nr_atendimento;
 
if (nr_internacao_w IS NOT NULL AND nr_internacao_w::text <> '') and (coalesce(nr_seq_unidade_w, 0) <> nr_seq_unid_destino_p) then 
 
	 
 
	select	max(nm_setor_integracao), 
		max(cd_setor_atendimento) 
	into STRICT	nm_setor_integracao_w, 
		cd_setor_atendimento_w 
	from	unidade_atendimento 
	where	nr_seq_interno = nr_seq_unid_destino_p;
 
	cd_enfermaria_w := trim(both substr(nm_setor_integracao_w, 1, position(';' in nm_setor_integracao_w) - 1));	
	nm_setor_integracao_w := substr(nm_setor_integracao_w, position(';' in nm_setor_integracao_w) + 1, length(nm_setor_integracao_w));
	cd_leito_w 	:= trim(both substr(nm_setor_integracao_w, 1, position(';' in nm_setor_integracao_w)- 1));
	if (position(';' in nm_setor_integracao_w) > 0) then 
		nm_setor_integracao_w := substr(nm_setor_integracao_w, position(';' in nm_setor_integracao_w) + 1, length(nm_setor_integracao_w));
		cd_dig_leito_w	:= trim(both nm_setor_integracao_w);
	else 
		cd_dig_leito_w	:= null;
	end if;
	 
 
	select	max(cd_setor_externo) 
	into STRICT	cd_setor_destino_w 
	from	setor_atendimento 
	where	cd_setor_atendimento = cd_setor_atendimento_w;
 
	if (cd_setor_destino_w IS NOT NULL AND cd_setor_destino_w::text <> '') and (cd_enfermaria_w IS NOT NULL AND cd_enfermaria_w::text <> '') and (cd_leito_w IS NOT NULL AND cd_leito_w::text <> '') then 
		 
		ds_sep_bv_w := ';';
		if (ie_sincrona_p = 'N') then 
			CALL gravar_agend_integracao(331, 'IDF_INTERNACAO='		|| nr_internacao_w 		|| ds_sep_bv_w || 
										'COD_POSTO_ENFERMAGEM='	|| cd_setor_destino_w	|| ds_sep_bv_w || 
										'COD_ENFERMARIA='		|| cd_enfermaria_w	 	|| ds_sep_bv_w || 
										'COD_LEITO='			|| cd_leito_w		 	|| ds_sep_bv_w || 
										'COD_DIGITO_LEITO='		|| cd_dig_leito_w		|| ds_sep_bv_w || 
										'DES_USUARIO='			|| ds_usuario_w			|| ds_sep_bv_w);
		else 
			idf_internacao_p		:= nr_internacao_w;
			cod_posto_enfermagem_p	:= cd_setor_destino_w;
			cod_enfermaria_p		:= cd_enfermaria_w;
			cod_leito_p				:= cd_leito_w;		
			cod_digito_leito_p		:= cd_dig_leito_w;	
			des_usuario_p			:= ds_usuario_w;
			 
		end if;
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aghos_transferencia_interna_ws ( nr_atendimento_p bigint, nr_seq_unid_destino_p bigint, nm_usuario_p text, ie_sincrona_p text default 'N', idf_internacao_p INOUT bigint DEFAULT NULL, cod_posto_enfermagem_p INOUT text DEFAULT NULL, cod_enfermaria_p INOUT text DEFAULT NULL, cod_leito_p INOUT text DEFAULT NULL, cod_digito_leito_p INOUT text DEFAULT NULL, des_usuario_p INOUT text  DEFAULT NULL) FROM PUBLIC;

