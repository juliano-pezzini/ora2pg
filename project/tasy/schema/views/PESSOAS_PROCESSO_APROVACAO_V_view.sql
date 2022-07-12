-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pessoas_processo_aprovacao_v (nr_sequencia, nr_seq_proc_aprov, dt_liberacao, cd_pessoa_fisica, nm_pessoa_fisica, nm_usuario, ie_aprov_reprov) AS select	p.nr_sequencia,
	p.nr_seq_proc_aprov,
	p.dt_liberacao,
	p.cd_pessoa_fisica,
	f.nm_pessoa_fisica,
	u.nm_usuario,
	p.ie_aprov_reprov
FROM	usuario u,
	pessoa_fisica f,
	processo_aprov_compra p
where	p.cd_pessoa_fisica = f.cd_pessoa_fisica
and	p.cd_pessoa_fisica is not null
and	f.cd_pessoa_fisica = u.cd_pessoa_fisica
and	u.ie_situacao <> 'I'

union all

select	p.nr_sequencia,
	p.nr_seq_proc_aprov,
	p.dt_liberacao,
	f.cd_pessoa_fisica,
	f.nm_pessoa_fisica,
	u.nm_usuario,
	p.ie_aprov_reprov
from	usuario u,
	pessoa_fisica f,
	processo_aprov_compra p
where	f.cd_cargo = p.cd_cargo
and	p.cd_cargo is not null
and	u.ie_situacao <> 'I'
and	f.cd_pessoa_fisica = u.cd_pessoa_fisica;
