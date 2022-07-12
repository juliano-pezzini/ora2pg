-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.imp_dpc_stem7_points ( qt_point_p bigint, cd_kcode_p text, nr_seq_edition_p bigint, nm_usuario_p text ) AS $body$
BEGIN


insert into dpc_stem7_points(
	QT_POINT,                  
	CD_KCODE,                 
	NR_STEM7_EDITION,          
	NM_USUARIO, 
	DT_ATUALIZACAO,
	IE_SITUACAO,
	NR_SEQUENCIA
	)
	values (
	qt_point_p,                  
	cd_kcode_p, 
	nr_seq_edition_p,
	nm_usuario_p,
	clock_timestamp(),
	'A',
	nextval('dpc_stem7_points_seq'));
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.imp_dpc_stem7_points ( qt_point_p bigint, cd_kcode_p text, nr_seq_edition_p bigint, nm_usuario_p text ) FROM PUBLIC;
