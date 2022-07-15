-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE def_all_item_approval (nr_seq_inventario_p bigint, nm_usuario_p text) AS $body$
DECLARE

							
authorized_count_w smallint;
qt_inventario_w smallint;
qt_inventario_wp smallint;


BEGIN
 SELECT  COUNT(*) into STRICT authorized_count_w
 FROM SUP_AUTORIZA_INVENTARIO a ,USUARIO b
	WHERE b.nm_usuario               = nm_usuario_p
	AND a.IE_TIPO_INVENTARIO         IN ('B','A')
	AND coalesce(IE_AUTOMATIC_APPROVAL,'N')='S'
    AND a.DT_INICIO                  <=clock_timestamp()
	AND a.DT_FINAL                   >= clock_timestamp()
	AND a.CD_PESSOA_AUTORIZADA       =b.CD_PESSOA_FISICA;
     if (authorized_count_w > 0) then
        select count(*) into STRICT qt_inventario_w from inventario_material where nr_seq_inventario = nr_seq_inventario_p;
        select count(*) into STRICT qt_inventario_wp from inventario_material where nr_seq_inventario=nr_seq_inventario_p and (qt_inventario IS NOT NULL AND qt_inventario::text <> '');
             if (qt_inventario_w=qt_inventario_wp)then
              Update	inventario
	         set dt_aprovacao = clock_timestamp(),
		     nm_usuario_aprov = nm_usuario_p
             where nr_sequencia = nr_seq_inventario_p;
               commit;
             end if;
         end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE def_all_item_approval (nr_seq_inventario_p bigint, nm_usuario_p text) FROM PUBLIC;

