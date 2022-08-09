-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ocup_enviar_sms_perct_ocup ( nm_usuario_p text) AS $body$
DECLARE

qt_percentual_w		double precision;
qt_regra_w		bigint;
nr_seq_regra_w		bigint;
id_sms_w		bigint;
ds_destino_w		varchar(500);
ds_mensagem_w		varchar(120);
ds_remetente_w		varchar(50);
lista_telefones_w	dbms_sql.varchar2_table;
ds_telefones_w		varchar(600);
ie_consist_destinatario_w	varchar(1);
BEGIN
ie_consist_destinatario_w := Obter_Param_Usuario(0, 214, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_consist_destinatario_w);
 
select	count(*) 
into STRICT	qt_regra_w 
from	regra_envio_sms_ocup;
 
if (coalesce(qt_regra_w,0) > 0) then 
		 
	SELECT round((Obter_percetual_ocupacao( 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unidades_setor END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unidades_temporarias END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unidades_ocupadas END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE qt_unidade_acomp END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unidades_interditadas END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unidades_livres END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unidades_higienizacao END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unidades_reservadas END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE qt_unidades_isolamento END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE qt_unidades_alta END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unid_temp_ocup END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unid_temp_ocupadas END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE qt_unid_temp_acomp END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unid_temp_interditadas END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unid_temp_livres END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unid_temp_higienizacao END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE nr_unid_temp_reservadas END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE qt_unid_temp_isolamento END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE qt_unid_temp_alta END ), 
					SUM(CASE WHEN ie_ocup_hospitalar='M' THEN 0 WHEN ie_ocup_hospitalar='T' THEN 0  ELSE qt_unidade_manutencao END ), 
					'X'))::numeric,3) 
	into STRICT	qt_percentual_w 
	FROM  	total_ocupacao_setores_v2 
	WHERE 	ie_ocup_hospitalar IN ('S','M','T');
	 
	 
	begin 
		select	nr_sequencia 
		into STRICT	nr_seq_regra_w 
		from	regra_envio_sms_ocup where	nr_perc_ocupacao <= qt_percentual_w 
		and	(nr_perc_ocupacao IS NOT NULL AND nr_perc_ocupacao::text <> '') 
		order by nr_perc_ocupacao desc LIMIT 1;
	exception 
	when no_data_found then 
		nr_seq_regra_w	:= 0;
	end;
 
	 
	if (coalesce(nr_seq_regra_w,0) > 0) then 
		 
		select	max(ds_destino), 
			max(ds_mensagem), 
			max(ds_remetente) 
		into STRICT	ds_destino_w, 
			ds_mensagem_w, 
			ds_remetente_w 
		from	regra_envio_sms_ocup 
		where	nr_sequencia = nr_seq_regra_w;
		 
			ds_telefones_w := ds_destino_w;
 
			lista_telefones_w := obter_lista_string(ds_telefones_w, ',');
 
			for	indice in lista_telefones_w.first..lista_telefones_w.last loop 
			 if (ie_consist_destinatario_w = 'S') then 
			 begin 
				if (substr(lista_telefones_w(indice),1,2) <> '55') then 
					id_sms_w := wheb_sms.enviar_sms(ds_remetente_w, '55'||lista_telefones_w(indice), ds_mensagem_w, nm_usuario_p, id_sms_w);
				else 
					id_sms_w := wheb_sms.enviar_sms(ds_remetente_w, lista_telefones_w(indice), ds_mensagem_w, nm_usuario_p, id_sms_w);
				end if;
			 end;
			 else 
				id_sms_w := wheb_sms.enviar_sms(ds_remetente_w, lista_telefones_w(indice), ds_mensagem_w, nm_usuario_p, id_sms_w);
			 end if;
				 
			end loop;
				 
	end if;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ocup_enviar_sms_perct_ocup ( nm_usuario_p text) FROM PUBLIC;
