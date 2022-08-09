-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hsl_gerar_epimed_internacao ( cd_setor_atendimento_p bigint, dt_entrada_unidade_p timestamp, nr_seq_interno_p bigint, nr_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nm_usuario_p text, dt_saida_unidade_p timestamp, cd_classif_setor_p text, ie_situacao_p text) AS $body$
DECLARE



cd_pessoa_fisica_w	varchar(10);
ie_sexo_w		varchar(1);
dt_entrada_w		timestamp;
nr_sequencia_w		bigint;	
nm_pessoa_fisica_w	varchar(60);
nr_prontuario_w		bigint;
ds_setor_atendimento_w	varchar(100);	
qt_mov_setor_w		bigint;
qt_internacao_w		bigint;
qt_mov_mesmo_setor_w	bigint;
qt_reinternacao_w		bigint;
qt_reint_w		bigint;
ie_tipo_reinter_w		bigint;
qt_saida_uti_w		bigint;
qt_passagens_uti_w 	bigint;
ie_tipo_movimentacao_w 	smallint;
--cd_unidade_basica_w	varchar2(10);
cd_estabelecimento_w	smallint;
dt_nascimento_w		timestamp;
nr_identidade_w		varchar(15);
ie_tipo_saida_w		smallint;
dt_saida_w		timestamp;
cd_motivo_alta_w		smallint;
dt_alta_w		timestamp;
ie_obito_w		varchar(1);
dt_saida_unidade_w	timestamp;
setor_integracao_w	varchar(10);
unidade_integracao_w	varchar(40);
ie_epimed_w		varchar(3);
cd_classif_setor_w	bigint;

BEGIN

/*
CREATE TABLE HSL_EPIMED_INTERNACAO_UTI (NR_SEQUENCIA   NUMBER(10) NOT NULL,
				        DT_ATUALIZACAO DATE NOT NULL,
					NM_USUARIO     VARCHAR2(15) NOT NULL,
					DT_ATUALIZACAO_NREC DATE NOT NULL,
					NM_USUARIO_NREC VARCHAR2(15) NOT NULL,
					DT_LEITURA	DATE,
					NM_PESSOA_FISICA VARCHAR2(60),
					IE_SEXO		VARCHAR2(1),
					IE_TIPO_DOCUMENTO VARCHAR2(3),
					CD_HOSPITAL 	NUMBER(4) NOT NULL,
					IE_TIPO_MOVIMENTACAO NUMBER(2) NOT NULL,
					NR_ATENDIMENTO NUMBER(10) NOT NULL,
					DT_ENTRADA	DATE,
					NR_INTERNACAO	NUMBER(10),
					NR_SEQ_INTERNO	NUMBER(10),
					DT_ENTRADA_UNIDADE DATE,
					CD_SETOR_ATENDIMENTO NUMBER(5),
					DT_REINTERNACAO	DATE,
					QT_PASSAGEM	NUMBER(10),
					IE_TIPO_REINTERNACAO NUMBER(2),
					CD_UNIDADE	VARCHAR2(10),
					NR_PRONTUARIO number(10),
					NR_DOCUMENTO VARCHAR2(80), 
					IE_TIPO_SAIDA NUMBER(2), 
					DT_SAIDA DATE, 
					DT_NASCIMENTO DATE, 
					DS_SETOR VARCHAR2(100),
					SETOR_INTEGRACAO varchar2(10),
					UNIDADE_INTEGRACAO varchar2(40)
					DS_ERRO VARCHAR2(255));
*/
if (ie_situacao_p = 'T') then

	qt_internacao_w 	:= hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'I');
	qt_mov_mesmo_setor_w 	:= hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'M');
	qt_mov_setor_w 		:= hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'D');
	qt_reinternacao_w 	:= hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'R');
	ie_tipo_reinter_w       := hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'TR');
	qt_saida_uti_w		:= hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'SU');
	qt_passagens_uti_w      := hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'P');
	qt_reint_w		:= hsl_obter_dados_inter_uti(nr_atendimento_p,cd_setor_atendimento_p,'RI');
end if;

ie_tipo_movimentacao_w  := 0;
--cd_unidade_basica_w	:= null;
cd_estabelecimento_w    := coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);
dt_saida_unidade_w      := dt_saida_unidade_p;


select	cd_pessoa_fisica,
	dt_entrada,
	coalesce(cd_motivo_alta,0),
	dt_alta
into STRICT	cd_pessoa_fisica_w,
	dt_entrada_w,
	cd_motivo_alta_w,
	dt_alta_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;

select	substr(nm_pessoa_fisica,1,60),
	nr_prontuario,
	substr(ie_sexo,1,1),
	dt_nascimento,
	substr(nr_identidade,1,15)
into STRICT	nm_pessoa_fisica_w,
	nr_prontuario_w,
	ie_sexo_w,
	dt_nascimento_w,
	nr_identidade_w	
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_w;

select	substr(ds_setor_atendimento,1,100),
	substr(cd_setor_externo,1,10),
	coalesce(ie_epimed,'N'),
	cd_classif_setor
into STRICT	ds_setor_atendimento_w,
	setor_integracao_w,
	ie_epimed_w,
	cd_classif_setor_w
from	setor_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p;

select	substr(max(nm_setor_integracao),1,40)
into STRICT	unidade_integracao_w
from	unidade_atendimento
where	cd_setor_atendimento = cd_setor_atendimento_p
and	cd_unidade_basica = cd_unidade_basica_p
and	cd_unidade_compl = cd_unidade_compl_p;


if	(((cd_classif_setor_p = 4) or (ie_epimed_w = 'S')) and (ie_situacao_p = 'T')) then

	if (qt_internacao_w = 0) then
		
		ie_tipo_movimentacao_w 	:= 1;
		qt_passagens_uti_w     	:= 1;
		qt_reint_w             	:= null;
		ie_tipo_reinter_w      	:= null;
		dt_saida_unidade_w	:= null;
		ie_tipo_saida_w		:= null;
						
	elsif (qt_mov_mesmo_setor_w = 1) then -- movimentacao para leito do mesmo setor de UTI
		
		ie_tipo_movimentacao_w 	:= 2;
		qt_reint_w              := null;
		ie_tipo_reinter_w       := null;
		dt_saida_unidade_w	:= null;
		ie_tipo_saida_w		:= null;
							
	elsif (qt_mov_setor_w = 1) then    -- movimentacao para outro setor de UTI
	
		ie_tipo_movimentacao_w 	:= 3;
		qt_reint_w             	:= null;
		ie_tipo_reinter_w      	:= null;
		dt_saida_unidade_w	:= null;
		ie_tipo_saida_w         := null;
		
	elsif (qt_reinternacao_w > 0) then -- retorno para um setor de UTI	
		ie_tipo_movimentacao_w 	:= 1;
		--cd_unidade_basica_w 	:= cd_unidade_basica_p;
		dt_saida_unidade_w	:= null;
		ie_tipo_saida_w		:= null;
		
	end if;
elsif (qt_saida_uti_w > 0) then -- saida do setor de UTI
	
		ie_tipo_movimentacao_w := 4;
		qt_reint_w             := null;
		ie_tipo_reinter_w      := null;
		qt_passagens_uti_w     := null;
		ie_tipo_saida_w        := null;
		
elsif (ie_situacao_p = 'A') then

	if (cd_motivo_alta_w > 0) then
		select	coalesce(max(ie_obito),'N')
		into STRICT	ie_obito_w
		from	motivo_alta
		where	cd_motivo_alta = cd_motivo_alta_w;
		if (ie_obito_w = 'S') then
			ie_tipo_saida_w := 2;
		else
			ie_tipo_saida_w := 1;
		end if;
		
	else
		ie_tipo_saida_w := null;
	end if;
	ie_tipo_movimentacao_w := 4;
	qt_reint_w             := null;
	ie_tipo_reinter_w      := null;
	qt_passagens_uti_w     := null;
	
end if;

if (ie_tipo_movimentacao_w <> 0) then

		insert	into HSL_EPIMED_INTERNACAO_UTI(NR_SEQUENCIA,
							DT_ATUALIZACAO,
							NM_USUARIO,
							DT_ATUALIZACAO_NREC,
							NM_USUARIO_NREC,
							NM_PESSOA_FISICA,
							IE_SEXO,
							IE_TIPO_DOCUMENTO,
							CD_HOSPITAL,
							IE_TIPO_MOVIMENTACAO,
							NR_ATENDIMENTO,
							DT_ENTRADA,
							NR_INTERNACAO,
							NR_SEQ_INTERNO,
							DT_ENTRADA_UNIDADE,
							CD_SETOR_ATENDIMENTO,
							DS_SETOR,
							NR_PRONTUARIO,
							CD_UNIDADE,
							DT_REINTERNACAO,
							QT_PASSAGEM,
							IE_TIPO_REINTERNACAO,
							DT_NASCIMENTO,
							NR_DOCUMENTO,
							IE_TIPO_SAIDA,          
							DT_SAIDA,
							SETOR_INTEGRACAO,
							UNIDADE_INTEGRACAO,
							CD_MOTIVO_ALTA,
							DT_ALTA)
				values (nextval('hsl_epimed_internacao_uti_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					substr(obter_nome_pf(cd_pessoa_fisica_w),1,60),
					ie_sexo_w,
					'RG',
					cd_estabelecimento_w,
					ie_tipo_movimentacao_w,
					nr_atendimento_p,
					dt_entrada_w,
					qt_passagens_uti_w,
					nr_seq_interno_p,
					dt_entrada_unidade_p,
					cd_setor_atendimento_p,
					ds_setor_atendimento_w,
					nr_prontuario_w,
					cd_unidade_basica_p,
					dt_entrada_unidade_p,
					qt_reint_w,
					ie_tipo_reinter_w,
					dt_nascimento_w,
					nr_identidade_w,
					ie_tipo_saida_w,
					dt_saida_unidade_w,
					setor_integracao_w,
					unidade_integracao_w,
					cd_motivo_alta_w,
					dt_alta_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hsl_gerar_epimed_internacao ( cd_setor_atendimento_p bigint, dt_entrada_unidade_p timestamp, nr_seq_interno_p bigint, nr_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, nm_usuario_p text, dt_saida_unidade_p timestamp, cd_classif_setor_p text, ie_situacao_p text) FROM PUBLIC;
