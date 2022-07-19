-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sip_consistir_lote ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE

qt_beneficiario_w	bigint;
qt_evento_w		bigint;
nr_seq_item_sip_w	bigint;
sg_uf_w			varchar(10);
ie_tipo_contratacao_w	varchar(2);
ie_segmentacao_sip_w	smallint;
qt_beneficiario_ww	bigint;
vl_despesa_w		double precision;
qt_evento_ww		bigint;

C01 CURSOR FOR
	SELECT	coalesce(qt_beneficiario,0),
		coalesce(qt_evento,0),
		nr_seq_item_sip,
		ie_tipo_contratacao,
		ie_segmentacao_sip,
		coalesce(sg_uf,''),
		coalesce(vl_despesa,0)
	from	sip_lote_item_assistencial
	where	nr_seq_lote 	= nr_seq_lote_p
	group by
		qt_beneficiario,
		qt_evento,
		nr_seq_item_sip,
		ie_tipo_contratacao,
		ie_segmentacao_sip,
		sg_uf,
		vl_despesa;

BEGIN
CALL sip_deletar_inconsistencia(nr_seq_lote_p,nm_usuario_p);
open C01;
loop
fetch C01 into
	qt_beneficiario_w,
	qt_evento_w,
	nr_seq_item_sip_w,
	ie_tipo_contratacao_w,
	ie_segmentacao_sip_w,
	sg_uf_w,
	vl_despesa_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (nr_seq_item_sip_w in ( 1, 2, 28, 29, 35, 38, 46, 50, 57, 64, 71, 79, 84, 85, 87, 110, 111, 112, 113, 116, 117, 118, 119, 122, 120, 121, 123)) then
		if	(( qt_evento_w 	> 0 ) 	or (vl_despesa_w	> 0 ))  and (qt_beneficiario_w = 0 )	then
				CALL sip_inserir_inconsistencia(4,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
							   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
							   vl_despesa_w, nr_seq_item_sip_w );
		end if;
	end if;

	if ( nr_seq_item_sip_w = 28 ) then
		begin
		qt_beneficiario_ww	:= 0;
		select	coalesce(sum(qt_beneficiario),0)
		into STRICT 	qt_beneficiario_ww
		from 	sip_Lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		= 1
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_beneficiario_ww > qt_beneficiario_w ) then
			CALL sip_inserir_inconsistencia(1,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;
	if ( nr_seq_item_sip_w = 65 ) then
		begin
		qt_evento_ww	:= 0;
		select 	coalesce(sum(qt_evento),0)
		into STRICT 	qt_evento_ww
		from	sip_lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		in (66,67,75,78,82)
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_evento_ww <> qt_evento_w ) then
			CALL sip_inserir_inconsistencia(2,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;
	if ( nr_seq_item_sip_w = 64 ) then
		begin
		qt_evento_ww	:= 0;
		select 	coalesce(sum(qt_evento),0)
		into STRICT 	qt_evento_ww
		from	sip_lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and	nr_seq_item_sip		= 83
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_evento_ww <> qt_evento_w ) then
			CALL sip_inserir_inconsistencia(3,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;

	if (nr_seq_item_sip_w = 46) then
		begin
		qt_beneficiario_ww	:= 0;
		select	coalesce(sum(qt_beneficiario),0)
		into STRICT 	qt_beneficiario_ww
		from 	sip_Lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		= 35
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_beneficiario_ww <= qt_beneficiario_w ) then
			CALL sip_inserir_inconsistencia(5,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;
	if (nr_seq_item_sip_w = 38) then
		begin
		qt_beneficiario_ww	:= 0;
		select	coalesce(sum(qt_beneficiario),0)
		into STRICT 	qt_beneficiario_ww
		from 	sip_Lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		= 35
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_beneficiario_ww <= qt_beneficiario_w ) then
			CALL sip_inserir_inconsistencia(6,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;
	if (nr_seq_item_sip_w = 50) then
		begin
		qt_beneficiario_ww	:= 0;
		select	coalesce(sum(qt_beneficiario),0)
		into STRICT 	qt_beneficiario_ww
		from 	sip_Lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		= 35
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_beneficiario_ww <= qt_beneficiario_w ) then
			CALL sip_inserir_inconsistencia(7,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;
	if (nr_seq_item_sip_w = 83) then
		begin
		qt_evento_ww	:= 0;
		select 	coalesce(sum(qt_evento),0)
		into STRICT 	qt_evento_ww
		from	sip_lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		in (84,85,87)
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_evento_ww <> qt_evento_w ) then
			CALL sip_inserir_inconsistencia(8,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;

	if (nr_seq_item_sip_w = 65) then
		begin
		qt_evento_ww	:= 0;
		select 	coalesce(sum(qt_evento),0)
		into STRICT 	qt_evento_ww
		from	sip_lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		= 64
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_evento_ww <> qt_evento_w ) then
			CALL sip_inserir_inconsistencia(9,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;

	if (nr_seq_item_sip_w = 75) then
		begin
		qt_evento_ww	:= 0;
		select 	coalesce(sum(qt_evento),0)
		into STRICT 	qt_evento_ww
		from	sip_lote_item_assistencial
		where	nr_seq_lote		= nr_seq_lote_p
		and 	nr_seq_item_sip		in (76,77)
		and	((coalesce(ie_tipo_contratacao::text, '') = '')
		or (ie_tipo_contratacao =  ie_tipo_contratacao_w))
		and	((coalesce(ie_segmentacao_sip::text, '') = '')
		or (ie_segmentacao_sip	= ie_segmentacao_sip_w))
		and	((coalesce(sg_uf::text, '') = '')
		or (sg_uf = sg_uf_w));
		if ( qt_evento_ww > qt_evento_w ) then
			CALL sip_inserir_inconsistencia(10,nr_seq_lote_p,nm_usuario_p, ie_tipo_contratacao_w,
						   ie_segmentacao_sip_w, sg_uf_w, qt_evento_w, qt_beneficiario_w,
						   vl_despesa_w, nr_seq_item_sip_w );
		end if;
		end;
	end if;

	end;
end loop;
close C01;



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sip_consistir_lote ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

