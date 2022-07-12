-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_benef_rescid ( nr_seq_segurado_p bigint) RETURNS varchar AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Verificar a situação do beneficiário, se está rescindido ou não
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/dt_rescisao_w			timestamp;
dt_limite_utilizacao_w		timestamp;
ie_retorno_w			varchar(1) := 'N';


BEGIN

	select	max(dt_rescisao),
		max(fim_dia(dt_limite_utilizacao))
	into STRICT	dt_rescisao_w,
		dt_limite_utilizacao_w
	from	pls_segurado
	where	nr_sequencia	= nr_seq_segurado_p;

	if (dt_rescisao_w IS NOT NULL AND dt_rescisao_w::text <> '') and (trunc(clock_timestamp()) > dt_limite_utilizacao_w) then
		ie_retorno_w := 'S';
	end if;


return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_benef_rescid ( nr_seq_segurado_p bigint) FROM PUBLIC;

