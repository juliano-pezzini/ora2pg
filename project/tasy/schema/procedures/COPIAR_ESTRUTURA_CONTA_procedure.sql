-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copiar_estrutura_conta ( CD_CONVENIO_ORIGEM_P bigint, CD_CONVENIO_DESTINO_P bigint, CD_ESTRUTURA_P bigint, NM_USUARIO_P text, IE_COPIA_TODOS_P text) AS $body$
DECLARE


NR_SEQUENCIA_W			bigint := 0;
NR_SEQ_ANTERIOR_W		bigint := 0;
CD_ESTRUTURA_W			integer := 0;
DS_TITULO_W			varchar(80) := '';
NR_SEQ_CONTA_W			integer := 0;
IE_NOVA_PAGINA_W		varchar(1)  := '';
IE_SOMA_TOTAL_W			varchar(1)  := '';
IE_SINTETICO_W			varchar(1)  := '';
IE_TODA_PAGINA_W		varchar(1)  := '';
IE_TOTAL_ESTRUT_w		varchar(1)  := 'N';
IE_IMPRIME_ZERADO_w		varchar(1)  := 'N';
IE_IMPRIME_ITEM_ZERADO_w	varchar(1)  := 'N';
IE_STATUS_CONTA_W		smallint;
IE_CUSTO_OPER_ZERADO_w		varchar(01);
IE_TOTAL_DESCONTO_w		varchar(01)	:= 'N';
CD_ESTABELECIMENTO_W		convenio_estrutura_conta.cd_estabelecimento%type;
IE_REGRA_TOTAL_HONOR_W		convenio_estrutura_conta.ie_regra_total_honor%type;
IE_PROTOCOLO_W			varchar(1);
IE_SOMENTE_TOTAL_ESTRUT_W	convenio_estrutura_conta.ie_somente_total_estrut%type;

C01 CURSOR FOR
SELECT 	NR_SEQUENCIA,
	CD_ESTRUTURA,
	DS_TITULO,
	NR_SEQ_CONTA,
	IE_NOVA_PAGINA,
	IE_SOMA_TOTAL,
	IE_SINTETICO,
	IE_TODA_PAGINA,
	IE_TOTAL_ESTRUT,
	IE_IMPRIME_ZERADO,
	IE_IMPRIME_ITEM_ZERADO,
	IE_STATUS_CONTA,
	IE_CUSTO_OPER_ZERADO,
	IE_TOTAL_DESCONTO,
	CD_ESTABELECIMENTO,
	IE_REGRA_TOTAL_HONOR,
	IE_PROTOCOLO,
	IE_SOMENTE_TOTAL_ESTRUT
FROM CONVENIO_ESTRUTURA_CONTA
WHERE coalesce(CD_CONVENIO,0) = CD_CONVENIO_ORIGEM_P
  and 	((IE_COPIA_TODOS_P = 'S') or (cd_estrutura 	= cd_estrutura_p));


BEGIN

IF (IE_COPIA_TODOS_P = 'S') THEN
	DELETE FROM CONVENIO_ESTRUTURA_CONTA
	WHERE coalesce(CD_CONVENIO,0) = CD_CONVENIO_DESTINO_P;
end if;
OPEN C01;
LOOP
FETCH C01 INTO
        NR_SEQ_ANTERIOR_W,
	CD_ESTRUTURA_W,
	DS_TITULO_W,
	NR_SEQ_CONTA_W,
	IE_NOVA_PAGINA_W,
	IE_SOMA_TOTAL_W,
	IE_SINTETICO_W,
	IE_TODA_PAGINA_W,
	IE_TOTAL_ESTRUT_w,
	IE_IMPRIME_ZERADO_w,
	IE_IMPRIME_ITEM_ZERADO_w,
	IE_STATUS_CONTA_W,
	IE_CUSTO_OPER_ZERADO_w,
	IE_TOTAL_DESCONTO_w,
	CD_ESTABELECIMENTO_W,
	IE_REGRA_TOTAL_HONOR_W,
	IE_PROTOCOLO_W,
	IE_SOMENTE_TOTAL_ESTRUT_W;
EXIT WHEN NOT FOUND; /* apply on C01 */
	BEGIN
	SELECT MAX(NR_SEQUENCIA) + 1
       	INTO STRICT NR_SEQUENCIA_W
       	FROM CONVENIO_ESTRUTURA_CONTA;

	INSERT INTO CONVENIO_ESTRUTURA_CONTA(NR_SEQUENCIA,
		CD_ESTRUTURA,
		CD_CONVENIO,
		DS_TITULO,
		NR_SEQ_CONTA,
		IE_NOVA_PAGINA,
		NM_USUARIO,
		DT_ATUALIZACAO,
		IE_SOMA_TOTAL,
		IE_SINTETICO,
		IE_TODA_PAGINA,
		IE_TOTAL_ESTRUT,
		IE_IMPRIME_ZERADO,
		IE_IMPRIME_ITEM_ZERADO,
		IE_STATUS_CONTA,
		IE_CUSTO_OPER_ZERADO,
		IE_TOTAL_DESCONTO,
		CD_ESTABELECIMENTO,
		IE_REGRA_TOTAL_HONOR,
		IE_PROTOCOLO,
		IE_SOMENTE_TOTAL_ESTRUT)
	VALUES (NR_SEQUENCIA_W,
		CD_ESTRUTURA_W,
		CASE WHEN CD_CONVENIO_DESTINO_P=0 THEN null  ELSE CD_CONVENIO_DESTINO_P END ,
		DS_TITULO_W,
		NR_SEQ_CONTA_W,
		IE_NOVA_PAGINA_W,
		NM_USUARIO_P,
		clock_timestamp(),
		IE_SOMA_TOTAL_W,
		IE_SINTETICO_W,
		IE_TODA_PAGINA_W,
		IE_TOTAL_ESTRUT_w,
		IE_IMPRIME_ZERADO_w,
		IE_IMPRIME_ITEM_ZERADO_w,
		IE_STATUS_CONTA_W,
		IE_CUSTO_OPER_ZERADO_w,
		IE_TOTAL_DESCONTO_w,
		CD_ESTABELECIMENTO_W,
		IE_REGRA_TOTAL_HONOR_W,
		IE_PROTOCOLO_W,
		IE_SOMENTE_TOTAL_ESTRUT_W);

	INSERT INTO CONVENIO_ESTRUT_ATRIB(NR_SEQUENCIA,
		NM_ATRIBUTO,
		NR_SEQ_ATRIBUTO,
		DT_ATUALIZACAO,
		NM_USUARIO,
		NM_ALIAS,
		DS_MASCARA,
		IE_TOTALIZA,
		IE_QUEBRA,
		QT_TAMANHO,
		IE_IMPRIME,
		IE_SOMA_TOTAL,
		IE_SOMA_ESTRUTURA,
		QT_TAM_FONTE,
		NR_SEQ_INTERNO,
		IE_ESTENDER,
		NM_TABELA_CONVERSAO,
		NM_ATRIBUTO_CONVERSAO,
		NR_SEQ_ORDEM,
		IE_ORDENA_DECRESCENTE)
		SELECT	NR_SEQUENCIA_W,
			NM_ATRIBUTO,
			NR_SEQ_ATRIBUTO,
			clock_timestamp(),
			NM_USUARIO_P,
			NM_ALIAS,
			DS_MASCARA,
			IE_TOTALIZA,
			IE_QUEBRA,
			QT_TAMANHO,
			IE_IMPRIME,
			IE_SOMA_TOTAL,
			IE_SOMA_ESTRUTURA,
			QT_TAM_FONTE,
			nextval('convenio_estrut_atrib_seq'),
			IE_ESTENDER,
			NM_TABELA_CONVERSAO,
			NM_ATRIBUTO_CONVERSAO,
			NR_SEQ_ORDEM,
			IE_ORDENA_DECRESCENTE
		FROM CONVENIO_ESTRUT_ATRIB
		WHERE NR_SEQUENCIA = NR_SEQ_ANTERIOR_W;
	END;
END LOOP;
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copiar_estrutura_conta ( CD_CONVENIO_ORIGEM_P bigint, CD_CONVENIO_DESTINO_P bigint, CD_ESTRUTURA_P bigint, NM_USUARIO_P text, IE_COPIA_TODOS_P text) FROM PUBLIC;
