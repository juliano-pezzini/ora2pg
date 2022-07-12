-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_macro_regra_envio_comunic ( nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);
ie_evento_w	varchar(5);


BEGIN

select	max(ie_evento)
into STRICT	ie_evento_w
from	proj_regra_comunicado
where	nr_sequencia = nr_sequencia_p;

if (ie_evento_w in ('ICC', 'ECC', 'DCC')) then
	ds_retorno_w :=	'@NM_CONSULTOR = Nome do consultor' || chr(13) || chr(10) ||
			'@NM_CANAL = Nome do canal';
else
	ds_retorno_w :=	'@NR_PROJETO = Sequência do projeto' || chr(13) || chr(10) ||
			'@DS_TITULO = Título do Projeto' || chr(13) || chr(10) ||
			'@DS_CLIENTE = Nome do cliente' || chr(13) || chr(10) ||
			'@DT_INICIO_PREV = Data início previsto' || chr(13) || chr(10) ||
			'@CD_COORDENADOR = Coordenador' || chr(13) || chr(10) ||
			'@CD_GERENTE = Gerente do projeto' || chr(13) || chr(10) ||
			'@DT_VIRADA = Data da virada' || chr(13) || chr(10) ||
			'@DS_CAMPO(AGENDA) = Campo a ser monitorado da tabela PROJ_AGENDA' || chr(13) || chr(10) ||
			'@DS_CONSULTOR(AGENDA) = Consultor da agenda' || chr(13) || chr(10) ||
			'@DT_AGENDA(AGENDA) = Data da agenda' || chr(13) || chr(10) ||
			'@HR_INICIO(AGENDA) = Hora início da data da agenda' || chr(13) || chr(10) ||
			'@HR_FIM(AGENDA) = Hora fim da data da agenda';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_macro_regra_envio_comunic ( nr_sequencia_p bigint) FROM PUBLIC;

