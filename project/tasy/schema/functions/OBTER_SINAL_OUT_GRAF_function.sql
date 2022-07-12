-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sinal_out_graf (sinal_vital_p text, nr_seq_modelo_p bigint, vl_item_p text, nr_cirurgia_p bigint default null, nr_seq_pepo_p bigint default null) RETURNS varchar AS $body$
DECLARE

regraModelo CURSOR FOR
SELECT psv.ie_sinal_vital, sv.nm_atributo, pmsvr.qt_minimo,pmsvr.qt_maximo,pmsvr.qt_min_aviso,pmsvr.qt_max_aviso,
	   pmsvr.ds_mensagem_alerta,pmsvr.ds_mensagem_bloqueio, pmsvr.nr_sequencia nr_regra,pms.nr_seq_modelo
  from pepo_sv sv
  inner join pepo_sinal_vital psv on sv.ie_sinal_vital = psv.ie_sinal_vital
  inner join pepo_modelo_secao_sv pmsv on  pmsv.nr_seq_pepo_sv = psv.nr_sequencia
  inner join pepo_modelo_secao pms on pmsv.nr_seq_modelo_secao = pms.nr_sequencia
  inner join pepo_modelo_sec_sv_regra pmsvr on pmsvr.nr_seq_modelo_secao_sv = pmsv.nr_sequencia
where sv.ie_sinal_vital = sinal_vital_p
  and pms.nr_seq_modelo = nr_seq_modelo_p;

w_ie_retorno varchar(1) := 'N';
w_checkedByModel varchar(1) := 'N';
w_nr_atendimento bigint;
w_nm_atributo varchar(50);

BEGIN

for r1 in regraModelo loop
	w_checkedByModel := 'S';
	if ((r1.nr_regra IS NOT NULL AND r1.nr_regra::text <> '') and ((r1.qt_min_aviso IS NOT NULL AND r1.qt_min_aviso::text <> '') or  (r1.qt_max_aviso IS NOT NULL AND r1.qt_max_aviso::text <> ''))) then
		if (vl_item_p < r1.qt_min_aviso or vl_item_p > r1.qt_max_aviso) then
			w_ie_retorno := 'S';
		end if;
	end if;
end loop;

	if (w_checkedByModel = 'N') then
	
		select max(a.nr_atendimento) into STRICT w_nr_atendimento
		   from cirurgia a
		  where (((coalesce(nr_cirurgia_p,0) > 0) and (a.nr_cirurgia = nr_cirurgia_p)) or
				 ((coalesce(nr_seq_pepo_p,0) > 0) and (a.nr_seq_pepo = nr_seq_pepo_p)));
				
		select max(sv.nm_atributo) 
		  into STRICT w_nm_atributo
		  from pepo_sv sv
         inner join pepo_sinal_vital psv on sv.ie_sinal_vital = psv.ie_sinal_vital
         where sv.ie_sinal_vital = sinal_vital_p;
		
		if (w_nm_atributo IS NOT NULL AND w_nm_atributo::text <> '' AND w_nr_atendimento IS NOT NULL AND w_nr_atendimento::text <> '') then
		   w_ie_retorno := obter_se_limite_sinal_vital(w_nr_atendimento, w_nm_atributo, vl_item_p, wheb_usuario_pck.get_nm_usuario);
		end if;
		
	end if;
return w_ie_retorno;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sinal_out_graf (sinal_vital_p text, nr_seq_modelo_p bigint, vl_item_p text, nr_cirurgia_p bigint default null, nr_seq_pepo_p bigint default null) FROM PUBLIC;
