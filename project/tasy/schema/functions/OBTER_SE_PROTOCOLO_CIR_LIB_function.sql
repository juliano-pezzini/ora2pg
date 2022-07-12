-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_protocolo_cir_lib ( nr_seq_protocolo_p bigint, cd_medico_p text, cd_especialidade_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/*
	ie_opcao_p:
	U = Usuario
	I = Instituicao
	E = Especialidade
*/
ie_retorno_w	varchar(1) := 'N';


BEGIN
if (ie_opcao_p = 'U') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	FROM cirurgia_protocolo a
LEFT OUTER JOIN cirurgia_protocolo_medico b ON (a.nr_sequencia = b.nr_seq_protocolo)
WHERE a.nr_sequencia			=	nr_seq_protocolo_p and coalesce(a.ie_situacao,'A')	=	'A'  and ((a.cd_medico = cd_medico_p) or (b.cd_medico = cd_medico_p));
elsif (ie_opcao_p = 'I') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	FROM cirurgia_protocolo a
LEFT OUTER JOIN cirurgia_protocolo_medico b ON (a.nr_sequencia = b.nr_seq_protocolo)
WHERE a.nr_sequencia			=	nr_seq_protocolo_p and coalesce(a.ie_situacao,'A')	=	'A'  and ((a.cd_medico = cd_medico_p) or (b.cd_medico = cd_medico_p));
	if (ie_retorno_w = 'N') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_retorno_w
		from	cirurgia_protocolo a
		where	a.nr_sequencia			=	nr_seq_protocolo_p
		and		coalesce(a.ie_situacao,'A')	=	'A'
		and (coalesce(a.cd_medico::text, '') = '');
		if (ie_retorno_w = 'S') then
			select	coalesce(max('N'),'S')
			into STRICT	ie_retorno_w
			from	cirurgia_protocolo_medico
			where	nr_seq_protocolo	= nr_seq_protocolo_p;
		end if;
	end if;
elsif (ie_opcao_p = 'E') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_retorno_w
	from	cirurgia_protocolo
	where (cd_medico = cd_medico_p or coalesce(cd_medico::text, '') = '')
	and	((cd_especialidade = cd_especialidade_p) or (cd_especialidade_p = 0))
	and	nr_sequencia = nr_seq_protocolo_p
	and	coalesce(ie_situacao,'A')	= 'A';

	if (ie_retorno_w = 'N') then
		select	coalesce(max('S'),'N')
		into STRICT	ie_retorno_w
		from	cirurgia_protocolo_medico
		where	cd_medico = cd_medico_p
		and	nr_seq_protocolo = nr_seq_protocolo_p;
	end if;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_protocolo_cir_lib ( nr_seq_protocolo_p bigint, cd_medico_p text, cd_especialidade_p bigint, ie_opcao_p text) FROM PUBLIC;
