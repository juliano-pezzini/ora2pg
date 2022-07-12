-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tasy_index_v (tablespace_name, segment_type, quantidade) AS select 	tablespace_name,
		segment_type,
		count(*) quantidade
FROM 		user_segments
group by 	tablespace_name,
	 	segment_type;

