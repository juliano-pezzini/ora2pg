-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_itens_protocolos_pepo ( nr_seq_protocolo_p bigint, nr_seq_material_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_aplic_bolus_w		varchar(5);
ie_modo_registro_w		varchar(5);


BEGIN

select 	coalesce(a.ie_aplic_bolus,'N'),
	a.ie_modo_registro
into STRICT	ie_aplic_bolus_w,
	ie_modo_registro_w
from	agente_anestesico a,
	agente_anest_material b
where	a.nr_sequencia = b.nr_seq_agente
and	b.nr_sequencia = nr_seq_material_p;

insert into protocolo_agent_anest(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_protocolo,
	nr_seq_material,
	ie_aplic_bolus,
	ie_modo_registro)
values (
	nextval('protocolo_agent_anest_seq'),
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_protocolo_p,
	nr_seq_material_p,
	ie_aplic_bolus_w,
	ie_modo_registro_w);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_itens_protocolos_pepo ( nr_seq_protocolo_p bigint, nr_seq_material_p bigint, nm_usuario_p text) FROM PUBLIC;

