-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atuali_atend_categ_convenio (nm_usuario_p text, nr_seq_atend_pac_futuro_p bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_convenio_p INOUT text, cd_usuario_convenio_p INOUT text, dt_validade_carteira_p INOUT timestamp, qt_dia_internacao_p INOUT bigint, ie_guia_autorizada_p INOUT text, dt_validade_cart_glosa_p INOUT timestamp, nr_doc_convenio_p INOUT text, cd_senha_p INOUT text, qt_dias_autoriz_p INOUT bigint) AS $body$
DECLARE


cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_plano_convenio_w 	varchar(10);
cd_usuario_convenio_w 	varchar(30);
dt_validade_carteira_w 	timestamp;
qt_dia_internacao_w 	smallint;
ie_guia_autorizada_w 	varchar(20);
dt_validade_cart_glosa_w	timestamp;
nr_doc_convenio_w	varchar(20);
cd_senha_w		varchar(20);
qt_dias_autoriz_w		bigint;
nr_seq_atend_pac_futuro_w   bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_atend_pac_futuro_w
from	af_atend_convenio
where	nr_seq_atend_futuro = nr_seq_atend_pac_futuro_p;

if (coalesce(nr_seq_atend_pac_futuro_w,0) > 0) then
	select	cd_convenio,
		cd_categoria,
		cd_plano_convenio,
		cd_usuario_convenio,
		dt_validade_carteira,
		qt_dia_internacao,
		ie_guia_autorizada,
		dt_validade_cart_glosa,
		nr_doc_convenio,
		cd_senha,
		qt_dias_autoriz
	into STRICT	cd_convenio_w,
		cd_categoria_w,
		cd_plano_convenio_w,
		cd_usuario_convenio_w,
		dt_validade_carteira_w,
		qt_dia_internacao_w,
		ie_guia_autorizada_w,
		dt_validade_cart_glosa_w,
		nr_doc_convenio_w,
		cd_senha_w,
		qt_dias_autoriz_w
	from	af_atend_convenio
	where	nr_sequencia = nr_seq_atend_pac_futuro_w;

cd_convenio_p 		:= cd_convenio_w;
cd_categoria_p 		:= cd_categoria_w;
cd_plano_convenio_p 	:= cd_plano_convenio_w;
cd_usuario_convenio_p 	:= cd_usuario_convenio_w;
dt_validade_carteira_p 	:= dt_validade_carteira_w;
qt_dia_internacao_p 	:= qt_dia_internacao_w;
ie_guia_autorizada_p 	:= ie_guia_autorizada_w;
dt_validade_cart_glosa_p	:= dt_validade_cart_glosa_w;
nr_doc_convenio_p		:= nr_doc_convenio_w;
cd_senha_p		:= cd_senha_w;
qt_dias_autoriz_p		:= qt_dias_autoriz_w;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atuali_atend_categ_convenio (nm_usuario_p text, nr_seq_atend_pac_futuro_p bigint, cd_convenio_p INOUT bigint, cd_categoria_p INOUT text, cd_plano_convenio_p INOUT text, cd_usuario_convenio_p INOUT text, dt_validade_carteira_p INOUT timestamp, qt_dia_internacao_p INOUT bigint, ie_guia_autorizada_p INOUT text, dt_validade_cart_glosa_p INOUT timestamp, nr_doc_convenio_p INOUT text, cd_senha_p INOUT text, qt_dias_autoriz_p INOUT bigint) FROM PUBLIC;

