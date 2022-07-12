-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_evento_sip ( cd_classificacao_p text, ie_tipo_contratacao_p text, ie_segmentacao_sip_p bigint, sg_uf_p text) RETURNS bigint AS $body$
DECLARE


nr_seq_item_w			bigint;
qt_evento_w			bigint	:= 0;
qt_registro_w			bigint	:= 0;
cd_classificacao_w		varchar(20);

C01 CURSOR FOR
	SELECT	cd_classificacao
	from	sip_item_assistencial
	where	nr_seq_superior	= nr_seq_item_w;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_item_w
from	sip_item_assistencial
where	cd_classificacao	= cd_classificacao_p;

select	count(*)
into STRICT	qt_registro_w
from	sip_item_assistencial
where	nr_seq_superior	= nr_seq_item_w;

if (qt_registro_w	= 0) then
	select	coalesce(sum(qt_procedimento),0)
	into STRICT	qt_evento_w
	from	pls_conta_proc
	where	cd_classificacao_sip	= cd_classificacao_p
	and	ie_tipo_contratacao	= ie_tipo_contratacao_p
	and	ie_segmentacao_sip	= ie_segmentacao_sip_p
	and	sg_uf_sip		= sg_uf_p;
else
	open C01;
	loop
	fetch C01 into
		cd_classificacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		qt_evento_w	:= qt_evento_w + pls_obter_evento_sip(cd_classificacao_w, ie_tipo_contratacao_p, ie_segmentacao_sip_p,
							sg_uf_p);
		end;
	end loop;
	close C01;
end if;

return	qt_evento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_evento_sip ( cd_classificacao_p text, ie_tipo_contratacao_p text, ie_segmentacao_sip_p bigint, sg_uf_p text) FROM PUBLIC;

