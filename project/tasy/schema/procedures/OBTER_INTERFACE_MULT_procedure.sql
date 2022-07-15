-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_interface_mult ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_convenio_w			integer;
ie_tipo_atendimento_w	smallint;
ie_tipo_protocolo_w		smallint;
cd_interface_envio_w	integer;
cd_estabelecimento_w	smallint;
ds_sql_interface_w		varchar(2000);

c01 CURSOR FOR
SELECT	a.cd_interface_envio,
		a.ds_sql_interface
from	param_interface a
where	a.cd_convenio = cd_convenio_w
and		coalesce(a.ie_tipo_protocolo,ie_tipo_protocolo_w) = ie_tipo_protocolo_w
and		coalesce(a.cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
and		(a.ds_sql_interface IS NOT NULL AND a.ds_sql_interface::text <> '')

union

select	coalesce(a.cd_interface_envio, c.cd_interface_envio),
		b.ds_comando
from	interface b,
		protocolo_convenio a,
        param_interface c
where	a.nr_seq_protocolo = nr_seq_protocolo_p
and		a.cd_interface_envio = b.cd_interface
and		(b.ds_comando IS NOT NULL AND b.ds_comando::text <> '')

union

select	coalesce(a.cd_interface_envio, c.cd_interface_envio),
		b.ds_comando
from	interface b,
		convenio a,
        param_interface c,
        protocolo_convenio d
where	a.cd_convenio = cd_convenio_w
and     a.cd_convenio = c.cd_convenio
and     c.cd_interface_envio = b.cd_interface
and	(b.ds_comando IS NOT NULL AND b.ds_comando::text <> '')
and     a.cd_convenio = d.cd_convenio
and (d.ie_tipo_protocolo = c.ie_tipo_protocolo or coalesce(c.ie_tipo_protocolo::text, '') = '')
order by 1 desc;


BEGIN
	cd_interface_envio_w := null;
	ds_sql_interface_w	 := null;

	select	coalesce(max(cd_convenio),0),
			coalesce(max(ie_tipo_protocolo),0),
			max(cd_interface_envio),
			coalesce(max(cd_estabelecimento),0)
	into STRICT	cd_convenio_w,
			ie_tipo_protocolo_w,
			cd_interface_envio_w,
			cd_estabelecimento_w
	from	protocolo_convenio
	where	nr_seq_protocolo = nr_seq_protocolo_p;

    DELETE FROM PROTOCOLO_CONV_INTERF WHERE NR_SEQ_PROTOCOLO = nr_seq_protocolo_p;

	open c01;
	loop
		fetch	c01
		into	cd_interface_envio_w,
				ds_sql_interface_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			SELECT	REPLACE(LOWER(ds_sql_interface_w), ':nr_seq_protocolo', TO_CHAR(nr_seq_protocolo_p))
			INTO STRICT	ds_sql_interface_w
			;

			INSERT INTO PROTOCOLO_CONV_INTERF(
				NR_SEQUENCIA,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				NR_SEQ_PROTOCOLO,
				CD_INTERFACE,
				DS_SQL_INTERFACE
			)
			VALUES (
				nextval('protocolo_conv_interf_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_protocolo_p,
				cd_interface_envio_w,
				ds_sql_interface_w
			);
		end;
	end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_interface_mult ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;

