-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_contas_vigencia_lote ( nr_lote_contabil_p ctb_movimento.nr_lote_contabil%type, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w       varchar(2000);

BEGIN

update  ctb_movimento a
set     ds_consistencia     = substr(wheb_mensagem_pck.get_texto(455973),1,255),
        ie_validacao        = '27'
where   nr_lote_contabil    = nr_lote_contabil_p
and exists (
    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_debito = b.cd_conta_contabil
    and     (b.dt_inicio_vigencia IS NOT NULL AND b.dt_inicio_vigencia::text <> '')
    and     coalesce(b.dt_fim_vigencia,clock_timestamp()) is not null
    and (b.dt_inicio_vigencia > a.dt_movimento or b.dt_fim_vigencia < a.dt_movimento)

union

    SELECT  1
    from    conta_contabil b
    where   a.cd_conta_credito = b.cd_conta_contabil
    and     (b.dt_inicio_vigencia IS NOT NULL AND b.dt_inicio_vigencia::text <> '')
    and     coalesce(b.dt_fim_vigencia,clock_timestamp()) is not null
    and (b.dt_inicio_vigencia > a.dt_movimento or b.dt_fim_vigencia < a.dt_movimento));

if (FOUND) then
    ds_erro_w := wheb_mensagem_pck.get_texto(455973);
end if;

ds_erro_p   := substr(ds_erro_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_contas_vigencia_lote ( nr_lote_contabil_p ctb_movimento.nr_lote_contabil%type, ds_erro_p INOUT text) FROM PUBLIC;

