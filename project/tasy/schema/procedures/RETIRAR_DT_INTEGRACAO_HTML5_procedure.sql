-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE retirar_dt_integracao_html5 ( nr_prescricao_p bigint, nr_equipamento_p bigint, ie_exame_amostra_p text, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE

ie_atualizado_w	varchar(10);


BEGIN

if (ie_exame_amostra_p = 'S') then
	CALL retirar_dt_integracao_exame(nr_prescricao_p, nm_usuario_p);
else
	CALL retirar_data_integracao_eup_js(nr_prescricao_p, nr_equipamento_p);
end if;

select CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
into STRICT ie_atualizado_w
from prescr_procedimento
where nr_prescricao = nr_prescricao_p
and coalesce(dt_integracao::text, '') = '';

if (ie_atualizado_w = 'S') then
	--727078 A integração da prescrição #@NR_PRESCRICAO#@ foi desfeita.
	ds_retorno_p := wheb_mensagem_pck.get_texto(727078,'nr_prescricao='||nr_prescricao_p);
else
	--727077 prescr não encontrado
	ds_retorno_p := wheb_mensagem_pck.get_texto(727077);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE retirar_dt_integracao_html5 ( nr_prescricao_p bigint, nr_equipamento_p bigint, ie_exame_amostra_p text, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
