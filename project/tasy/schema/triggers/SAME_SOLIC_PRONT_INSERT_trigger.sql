-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS same_solic_pront_insert ON same_solic_pront CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_same_solic_pront_insert() RETURNS trigger AS $BODY$
declare

IE_TIPO_SOLICITACAO_w		varchar(3);
IE_URGENTE_w			varchar(3);
NR_SEQ_LOTE_w			bigint;
CD_PESSOA_SOLICITANTE_w		varchar(10);
DT_PREVISTA_w			timestamp;
IE_STATUS_w			varchar(3);
CD_ESTABELECIMENTO_w		smallint;
DT_SOLICITACAO_w		timestamp;
DT_DEVOLUCAO_PREVISTA_W		timestamp;
nr_seq_motivo_w			bigint;
cd_setor_solicitante_w		integer;
qt_reg_w	smallint;

BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger	= 'N')  then
	goto Final;
end if;
if (NEW.nr_seq_lote is not null) then

	select	IE_TIPO_SOLICITACAO,
		IE_URGENTE,
		NR_SEQUENCIA,
		CD_PESSOA_SOLICITANTE,
		DT_PREVISTA,
		IE_STATUS,
		CD_ESTABELECIMENTO,
		DT_SOLICITACAO,
		DT_DEVOLUCAO_PREVISTA,
		nr_seq_motivo,
		cd_setor_solicitante
	into STRICT	IE_TIPO_SOLICITACAO_w,
		IE_URGENTE_w,
		NR_SEQ_LOTE_w,
		CD_PESSOA_SOLICITANTE_w,
		DT_PREVISTA_w,
		IE_STATUS_w,
		CD_ESTABELECIMENTO_w,
		DT_SOLICITACAO_w,
		DT_DEVOLUCAO_PREVISTA_W,
		nr_seq_motivo_w,
		cd_setor_solicitante_w
	from	same_solic_pront_lote
	where	nr_sequencia		= NEW.nr_seq_lote;

	NEW.IE_TIPO_SOLICITACAO	:= IE_TIPO_SOLICITACAO_w;
	NEW.IE_URGENTE			:= IE_URGENTE_w;
	NEW.CD_PESSOA_SOLICITANTE	:= CD_PESSOA_SOLICITANTE_w;
	NEW.DT_PREVISTA		:= DT_PREVISTA_w;
	NEW.IE_STATUS			:= IE_STATUS_w;
	NEW.CD_ESTABELECIMENTO		:= CD_ESTABELECIMENTO_w;
	NEW.DT_SOLICITACAO		:= DT_SOLICITACAO_w;
	NEW.DT_DEVOLUCAO_PREVISTA	:= DT_DEVOLUCAO_PREVISTA_W;
	NEW.nr_seq_motivo		:= nr_seq_motivo_w;
	NEW.cd_setor_solicitante	:= cd_setor_solicitante_w;

end if;

<<Final>>
qt_reg_w	:= 0;

RETURN NEW;
end
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_same_solic_pront_insert() FROM PUBLIC;

CREATE TRIGGER same_solic_pront_insert
	BEFORE INSERT ON same_solic_pront FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_same_solic_pront_insert();
