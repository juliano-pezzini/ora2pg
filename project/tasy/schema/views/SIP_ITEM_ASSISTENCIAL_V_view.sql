-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sip_item_assistencial_v (nr_sequencia, nr_seq_apres, nr_seq_superior, ds_item_superior, ds_item) AS select	item_sip.nr_sequencia nr_sequencia,
	item_sip.nr_seq_apres nr_seq_apres,
	item_sip.nr_seq_superior nr_seq_superior,
	(select (item_sup.cd_classificacao || ' - ' || item_sup.ds_item)
	FROM	sip_item_assistencial item_sup
	where	item_sup.nr_sequencia = item_sip.nr_seq_superior) ds_item_superior,
	(item_sip.cd_classificacao || ' - ' || item_sip.ds_item) ds_item
from	sip_item_assistencial item_sip
order by item_sip.nr_seq_apres;
