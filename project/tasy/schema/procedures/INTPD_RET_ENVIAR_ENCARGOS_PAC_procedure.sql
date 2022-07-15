-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_ret_enviar_encargos_pac ( nr_sequencia_p bigint, ds_xml_p text) AS $body$
DECLARE

xml_base_w              xml;
nr_seq_documento_w      bigint;
nr_seq_item_documento_w bigint;
nr_seq_material_w       bigint;
nr_seq_procedimento_w   bigint;
nr_atendimento_w        bigint;
ie_status_w             varchar(3);
ie_status_atual_w		varchar(3);
nm_usuario_w            varchar(15);

c01 CURSOR FOR
	SELECT *
    FROM   XMLTABLE(
    	xmlnamespaces('http://schemas.xmlsoap.org/soap/envelope/' AS "soapenv", 'http://philipsstandardintegrator.philips.com/' AS "phil"),
		'/soapenv:Envelope/soapenv:Body/phil:integrationResponse/STRUCTURE' passing xml_base_w COLUMNS
    	id varchar(40) path 'ID',
		status varchar(10) path 'STATUS');
c01_w c01%ROWTYPE;


BEGIN
update	intpd_fila_transmissao
set		ds_xml_retorno = ds_xml_p,
		ie_response_procedure = 'S'
where	nr_sequencia = nr_sequencia_p;

xml_base_w := xmlparse(DOCUMENT, convert_from(, 'utf-8'));

open c01;
	loop
	fetch c01 into c01_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
close c01;

select	nr_seq_documento,
		nr_seq_item_documento
into STRICT	nr_seq_documento_w, nr_seq_item_documento_w
from	intpd_fila_transmissao
where	nr_sequencia = nr_sequencia_p;

if (nr_seq_item_documento_w = 1) then -- material
	select	nr_sequencia,
			nr_atendimento
	into STRICT	nr_seq_material_w,
			nr_atendimento_w
	from	material_atend_paciente
	where	nr_sequencia = nr_seq_documento_w;
elsif (nr_seq_item_documento_w = 2) then -- procedimento
	select 	nr_sequencia,
			nr_atendimento
	into STRICT   	nr_seq_procedimento_w, nr_atendimento_w
	from   	procedimento_paciente
	where  	nr_sequencia = nr_seq_documento_w;
elsif (nr_seq_item_documento_w = 3) then -- devolução de material
	select	a.nr_sequencia,
			a.nr_atendimento
	into STRICT	nr_seq_material_w,
			nr_atendimento_w
	from	material_atend_paciente a,
			intpd_devol_mat_proc b
	where	a.nr_sequencia = b.nr_seq_matpaci
	and		b.nr_sequencia = nr_seq_documento_w;
elsif (nr_seq_item_documento_w = 4) then -- devolução de procedimento
	select 	a.nr_sequencia,
			a.nr_atendimento
	into STRICT   	nr_seq_procedimento_w,
			nr_atendimento_w
	from   	procedimento_paciente a,
			intpd_devol_mat_proc b
	where  	a.nr_sequencia = b.nr_seq_propaci
	and		b.nr_sequencia = nr_seq_documento_w;
end if;

nm_usuario_w := 'WEBSERVICE';

select case
		 when ies.ie_tipo_utilizacao = 'S'
			  and upper(c01_w.status) = 'TRUE' then 'S'
		 when ies.ie_tipo_utilizacao = 'S'
			  and upper(c01_w.status) = 'FALSE' then 'E'
		 when ies.ie_tipo_utilizacao = 'A'
			  and upper(c01_w.status) = 'TRUE' then 'AEX'
		 when ies.ie_tipo_utilizacao = 'A'
			  and upper(c01_w.status) = 'FALSE' then 'E'
		 else 'E'
	   end
into STRICT	ie_status_w
from	intpd_eventos_sistema ies,
		intpd_fila_transmissao ift
where	ift.nr_sequencia = nr_sequencia_p
and		ies.nr_sequencia = ift.nr_seq_evento_sistema;

select 	ie_status
into STRICT	ie_status_atual_w
from	intpd_fila_transmissao
where	nr_sequencia = nr_sequencia_p;

if (ie_status_w <> 'AEX') or (ie_status_atual_w <> 'E' and (ie_status_atual_w <> 'P')) then
	begin
	update	intpd_fila_transmissao
	set		ie_status = ie_status_w
	where	nr_sequencia = nr_sequencia_p;

	insert into status_integr_conta_pac(nr_sequencia,
			dt_atualizacao,
			dt_atualizacao_nrec,
			nm_usuario,
			nm_usuario_nrec,
			nr_atendimento,
			nr_seq_matpaci,
			nr_seq_propaci,
			ie_status,
			nr_seq_fila_transm)
	values ( nextval('status_integr_conta_pac_seq'),
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_w,
			nm_usuario_w,
			nr_atendimento_w,
			nr_seq_material_w,
			nr_seq_procedimento_w,
			ie_status_w,
			nr_sequencia_p);
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_ret_enviar_encargos_pac ( nr_sequencia_p bigint, ds_xml_p text) FROM PUBLIC;

