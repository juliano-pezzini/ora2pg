-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_cad_proc ( nr_seq_registro_p bigint, ie_tipo_registro_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*	ie_tipo_registro_p
	C = Cobertura
	L = Limitação
	R = Carência
	O = Coparticipação
	T = Tipo coparticipação */
/* 	ie_opcao_p
	O = Descrição da origem do procedimento */
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_area_procedimento_w		bigint	:= null;
cd_especialidade_w		bigint	:= null;
cd_grupo_proc_w			bigint	:= null;
ie_origem_proced_ww		bigint	:= null;
ds_retorno_w			varchar(254);


BEGIN

begin
if (ie_tipo_registro_p = 'C') then
	select	cd_procedimento,
		ie_origem_proced,
		cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	pls_cobertura_proc
	where	nr_sequencia	= nr_seq_registro_p;
elsif (ie_tipo_registro_p = 'L') then
	select	cd_procedimento,
		ie_origem_proced,
		cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	pls_limitacao_proc
	where	nr_sequencia	= nr_seq_registro_p;
elsif (ie_tipo_registro_p = 'R') then
	select	cd_procedimento,
		ie_origem_proced,
		cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	pls_carencia_proc
	where	nr_sequencia	= nr_seq_registro_p;
elsif (ie_tipo_registro_p = 'O') then
	select	cd_procedimento,
		ie_origem_proced,
		cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w,
		cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	pls_coparticipacao_proc
	where	nr_sequencia	= nr_seq_registro_p;
elsif (ie_tipo_registro_p = 'T') then
	select	cd_procedimento_internacao,
		ie_origem_proced_internacao
	into STRICT	cd_procedimento_w,
		ie_origem_proced_w
	from	pls_tipo_coparticipacao
	where	nr_sequencia	= nr_seq_registro_p;
end if;

if	((cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') or (cd_area_procedimento_w IS NOT NULL AND cd_area_procedimento_w::text <> '') or (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') or (cd_grupo_proc_w IS NOT NULL AND cd_grupo_proc_w::text <> '')) then
	if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') then
		ie_origem_proced_ww	:= ie_origem_proced_w;
	elsif (cd_grupo_proc_w IS NOT NULL AND cd_grupo_proc_w::text <> '') then
		select	a.ie_origem_proced
		into STRICT	ie_origem_proced_ww
		from	grupo_proc c,
			especialidade_proc b,
			area_procedimento a
		where	a.cd_area_procedimento	= b.cd_area_procedimento
		and	b.cd_especialidade	= c.cd_especialidade
		and	c.cd_grupo_proc		= cd_grupo_proc_w;
	elsif (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') then
		select	a.ie_origem_proced
		into STRICT	ie_origem_proced_ww
		from	especialidade_proc b,
			area_procedimento a
		where	a.cd_area_procedimento	= b.cd_area_procedimento
		and	b.cd_especialidade	= cd_especialidade_w;
	elsif (cd_area_procedimento_w IS NOT NULL AND cd_area_procedimento_w::text <> '') then
		select	a.ie_origem_proced
		into STRICT	ie_origem_proced_ww
		from	area_procedimento a
		where	a.cd_area_procedimento	= cd_area_procedimento_w;
	end if;
end if;
exception
when others then
	ds_retorno_w  :=  '';
end;

if (ie_opcao_p	= 'O') then
	select	substr(obter_valor_dominio(30,ie_origem_proced_ww),1,255)
	into STRICT	ds_retorno_w
	;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_cad_proc ( nr_seq_registro_p bigint, ie_tipo_registro_p text, ie_opcao_p text) FROM PUBLIC;
