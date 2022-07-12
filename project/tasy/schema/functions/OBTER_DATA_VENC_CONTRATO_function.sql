-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_venc_contrato ( dt_inicial_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_vencimento_w timestamp;
dt_retorno_w			timestamp;
ie_ano_bisexto_w	varchar(1);


BEGIN

		begin
			ie_ano_bisexto_w := obter_se_ano_bisexto(dt_inicial_p);
		
			if (pkg_date_utils.extract_field('MONTH', dt_inicial_p, 0) = 2) then /*Se for fevereiro*/
			
				if (coalesce(ie_ano_bisexto_w,'N') = 'S' ) and (pkg_date_utils.extract_field('DAY', dt_vencimento_w, 0) > 29 ) then /*se for ano bisexto e o dia for maior que 29, nao pode pois fevereiro em ano bisexto tem apenas 29 dias*/
					
					dt_vencimento_w	:= PKG_DATE_UTILS.START_OF(pkg_date_utils.end_of(dt_inicial_p, 'MONTH', 0), 'DD'); /*pega o utimo dia do mes 02*/
				
				elsif (coalesce(ie_ano_bisexto_w,'N') = 'N' ) and (pkg_date_utils.extract_field('DAY', dt_vencimento_w, 0) > 28 ) then /*se n for bisexto e 28 dias*/
				
					dt_vencimento_w	:= PKG_DATE_UTILS.START_OF(pkg_date_utils.end_of(dt_inicial_p, 'MONTH', 0), 'DD'); /*pega o utimo dia do mes 02*/
					
				end if;
			
			else
			
				dt_vencimento_w	:= pkg_date_utils.get_date(pkg_date_utils.extract_field('DAY', dt_vencimento_w, 0), dt_inicial_p, 0);
				
			end if;
		
			/*if (to_char(dt_inicial_p,'mm') = 02) and ( to_char(dt_vencimento_w,'dd') >= 28 ) then /*se for fevereiro  nao tem 30 dias*/

				/*dt_vencimento_w	:= to_date(to_char(last_day(dt_vencimento_w),'dd/mm/yyyy'),'dd/mm/yyyy');
			else
				dt_vencimento_w	:= to_date(to_char(dt_vencimento_w,'dd') || '/' || to_char(dt_inicial_p,'mm/yyyy'),'dd/mm/yyyy');
			end if;*/
		exception when others then
				dt_vencimento_w := pkg_date_utils.get_datetime(pkg_date_utils.end_of(dt_inicial_p,'MONTH',0), coalesce(dt_inicial_p, PKG_DATE_UTILS.get_Time('00:00:00')));
				--wheb_mensagem_pck.exibir_mensagem_abort(316259,'NR_SEQ_CONTRATO_W=' || nr_seq_contrato_w);
		end;

return	dt_vencimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_venc_contrato ( dt_inicial_p timestamp) FROM PUBLIC;

