-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_leito_livre_reservado ( cd_pessoa_fisica_p text, ie_opcao_p text, ie_status_p text, ie_tipo_acao_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		 varchar(10);
nr_seq_gv_w		 bigint;
cd_setor_desejado_w 	 varchar(10);
cd_unidade_basica_w 	 varchar(10);
cd_unidade_compl_w  	 varchar(10);
cd_tipo_acomod_desej_w	 varchar(10);
ie_status_w		 varchar(2);
ie_status_vaga_w	varchar(2);
nr_atend_gv_w		bigint;

ie_consid_vaga_atendida_w	varchar(1);

/*	ie_opcao_p 
 
	A - Acomodação desejada 
	S - Setor desejado 
	UB - Unidade básica 
	UC - Unidade complementar 
	V - Vaga 
	D - Disponibilidade 
	ST - Situacao 
*/
 
 
/*	ie_status_p 
 
	L - Livre 
	A - Acomodado 
	I - Indisponivel 
	AB - Ambos (aguardando ou indisponivel ou sem gv) 
*/
 
 
/*	ie_tipo_acao_p 
 
	N - Normal 
	PS - Pronto Socorro 
*/
 
 

BEGIN 
ie_consid_vaga_atendida_w := Obter_param_Usuario(916, 935, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_consid_vaga_atendida_w);
 
ds_retorno_w := '';
 
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (cd_pessoa_fisica_p <> '0') then 
	if (ie_tipo_acao_p = 'N') then	 
		if (ie_consid_vaga_atendida_w = 'S') then 
			select	coalesce(max(nr_sequencia),0) 
			into STRICT	nr_seq_gv_w 
			from	gestao_vaga 
			where	cd_pessoa_fisica = cd_pessoa_fisica_p;
		else 
			select	coalesce(max(nr_sequencia),0) 
			into STRICT	nr_seq_gv_w 
			from	gestao_vaga 
			where	cd_pessoa_fisica = cd_pessoa_fisica_p 
			and	((coalesce(nr_atendimento::text, '') = '') or (nr_seq_agenda IS NOT NULL AND nr_seq_agenda::text <> '' AND nr_atendimento IS NOT NULL AND nr_atendimento::text <> ''));
		end if;		
	elsif (ie_tipo_acao_p = 'PS') then 
		select	coalesce(max(nr_sequencia),0) 
		into STRICT	nr_seq_gv_w 
		from	gestao_vaga 
		where	cd_pessoa_fisica = cd_pessoa_fisica_p 
		and	nr_atendimento = nr_atendimento_p;
	end if;
 
	select	coalesce(max(ie_status),'XX'), 
		coalesce(max(nr_atendimento),0) 
	into STRICT	ie_status_vaga_w, 
		nr_atend_gv_w 
	from	gestao_vaga 
	where	nr_sequencia = nr_seq_gv_w;
end if;
 
if (nr_seq_gv_w > 0) then 
	SELECT cd_setor_desejado, 
		cd_unidade_basica, 
		cd_unidade_compl, 
		cd_tipo_acomod_desej 
	into STRICT	cd_setor_desejado_w, 
		cd_unidade_basica_w, 
		cd_unidade_compl_w, 
		cd_tipo_acomod_desej_w 
	FROM 	gestao_vaga 
	WHERE 	nr_sequencia = nr_seq_gv_w;
 
	SELECT	max(ie_status_unidade) 
	into STRICT	ie_status_w 
	FROM	unidade_atendimento 
	WHERE	cd_setor_atendimento	= cd_setor_desejado_w 
	AND	((cd_unidade_basica 	= cd_unidade_basica_w) or (cd_unidade_basica = ' ')) 
	and	((cd_unidade_compl 	= cd_unidade_compl_w) or (cd_unidade_compl = ' '));
 
end if;
if	((ie_status_w = 'L') or (ie_status_w = 'R')) and (ie_status_vaga_w = 'R') and (ie_status_p = 'L') then 
	if (ie_opcao_p = 'S') then 
		ds_retorno_w := cd_setor_desejado_w;
	elsif (ie_opcao_p = 'UB') then 
		ds_retorno_w := cd_unidade_basica_w;
	elsif (ie_opcao_p = 'UC') then 
		ds_retorno_w := cd_unidade_compl_w;
	elsif (ie_opcao_p = 'A') then 
		ds_retorno_w := cd_tipo_acomod_desej_w;
	elsif (ie_opcao_p = 'V') then 
		ds_retorno_w := nr_seq_gv_w;
	end if;
elsif	((ie_status_w <> 'L')	or (nr_seq_gv_w = 0)) and (ie_status_p = 'I')	then 
		if (ie_opcao_p = 'D') then 
			ds_retorno_w := 'INDISP';
		elsif (ie_opcao_p = 'V') then 
			ds_retorno_w := nr_seq_gv_w;
		end if;
elsif	(ie_status_vaga_w = 'A' AND nr_atend_gv_w = 0) and (ie_status_p = 'A')	then		--tratar a trigger Agenda_Paciente_Atual para nao atualizar a gestao de vaga (criar parametro) 
	if (ie_opcao_p = 'V') then 
		ds_retorno_w := nr_seq_gv_w;
	end if;
elsif (ie_tipo_acao_p = 'PS') and (ie_status_p = 'AB') then 
	if (ie_opcao_p = 'V') and 
		((ie_status_vaga_w in ('A','R')) or (ie_status_w <> 'L' )) then 
			ds_retorno_w := nr_seq_gv_w;
	end if;
elsif (ie_tipo_acao_p = 'N') and (ie_status_p = 'AB') then 
	if (ie_opcao_p = 'ST') and 
		((ie_status_vaga_w = 'A') or (ie_status_w <> 'L' ) or (nr_seq_gv_w = 0)) then 
			ds_retorno_w := 'S';
	end if;
else 
	ds_retorno_w := '';
end if;
 
return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_leito_livre_reservado ( cd_pessoa_fisica_p text, ie_opcao_p text, ie_status_p text, ie_tipo_acao_p text, nr_atendimento_p bigint) FROM PUBLIC;

