-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pacote_v3 (cd_proced_pacote, nr_seq_pacote, ie_origem_proced, cd_procedimento, ds_observacao, ie_origem_proc, ds_pacote, ds_procedimento, ie_situacao, cd_convenio, cd_estabelecimento) AS select  distinct
	 a.cd_proced_pacote,
	 a.nr_seq_pacote,
	 a.ie_origem_proced,
	 b.cd_procedimento,
	 a.ds_observacao,
	 b.ie_origem_proced ie_origem_proc,
	 substr(obter_descricao_procedimento(a.cd_proced_pacote,a.ie_origem_proced),1,254) ds_pacote,
         substr(obter_descricao_procedimento(b.cd_procedimento, b.ie_origem_proced),1,254) ds_procedimento,
	 a.ie_situacao,
	 a.cd_convenio,
	 a.cd_estabelecimento
FROM     pacote a,
	 pacote_tipo_acomodacao b
where    a.ie_situacao     = 'A'
and 	a.nr_seq_pacote = b.nr_seq_pacote;

