-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_gerar_item_sup_assist ( nr_seq_lote_sip_p bigint, nr_seq_item_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_registro_w			bigint	:= 0;
nr_seq_item_w			bigint;
nr_seq_item_ww			bigint;
qt_evento_w			double precision;
qt_beneficiario_w		bigint;
vl_despesa_w			double precision;
nr_seq_superior_w		bigint;
sg_uf_w				varchar(2);
qt_registro_ww			bigint	:= 0;
seq_w	bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	sip_item_assistencial
	where	nr_seq_superior	= nr_seq_item_p;


BEGIN

select	count(*)
into STRICT	qt_registro_w
from	sip_item_assistencial
where	nr_seq_superior	= nr_seq_item_p;

if (qt_registro_w	> 0) then
	open C01;
	loop
	fetch C01 into
		nr_seq_item_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		CALL sip_gerar_item_sup_assist(nr_seq_lote_sip_p, nr_seq_item_w, nm_usuario_p);
		end;
	end loop;
	close C01;
end if;

select	count(*)
into STRICT	qt_registro_ww
from	sip_lote_item_assistencial
where	nr_seq_lote	= nr_seq_lote_sip_p
and	nr_seq_item_sip	= nr_seq_item_p;

if (qt_registro_ww	> 0) then
	select	coalesce(qt_evento,0),
		coalesce(qt_beneficiario,0),
		coalesce(vl_despesa,0),
		sg_uf
	into STRICT	qt_evento_w,
		qt_beneficiario_w,
		vl_despesa_w,
		sg_uf_w
	from	sip_lote_item_assistencial
	where	nr_seq_lote	= nr_seq_lote_sip_p
	and	nr_seq_item_sip	= nr_seq_item_p;

	select	nr_seq_superior
	into STRICT	nr_seq_superior_w
	from	sip_item_assistencial
	where	nr_sequencia	= nr_seq_item_p;

	select	count(*)
	into STRICT	qt_registro_ww
	from	sip_lote_item_assistencial
	where	nr_seq_lote	= nr_seq_lote_sip_p
	and	nr_seq_item_sip	= nr_seq_superior_w
	and	sg_uf		= sg_uf_w;

	if (nr_seq_superior_w	> 0) then
		if (qt_registro_ww	= 0) then
			insert into sip_lote_item_assistencial(nr_sequencia, nr_seq_lote, nr_seq_item_sip,
				sg_uf, qt_evento, qt_beneficiario,
				vl_despesa, dt_atualizacao, nm_usuario)
			values (	nextval('sip_lote_item_assistencial_seq'), nr_seq_lote_sip_p, nr_seq_superior_w,
				sg_uf_w, qt_evento_w, qt_beneficiario_w,
				vl_despesa_w, clock_timestamp(), nm_usuario_p);
		else
			select	coalesce(qt_evento,0) + qt_evento_w,
				coalesce(qt_beneficiario,0) + qt_beneficiario_w,
				coalesce(vl_despesa,0) + vl_despesa_w
			into STRICT	qt_evento_w,
				qt_beneficiario_w,
				vl_despesa_w
			from	sip_lote_item_assistencial
			where	nr_seq_lote	= nr_seq_lote_sip_p
			and	nr_seq_item_sip	= nr_seq_superior_w;

			update	sip_lote_item_assistencial
			set	qt_evento		= qt_evento_w,
				qt_beneficiario		= qt_beneficiario_w,
				vl_despesa		= vl_despesa_w
			where	nr_seq_lote		= nr_seq_lote_sip_p
			and	nr_seq_item_sip		= nr_seq_superior_w;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_gerar_item_sup_assist ( nr_seq_lote_sip_p bigint, nr_seq_item_p bigint, nm_usuario_p text) FROM PUBLIC;
