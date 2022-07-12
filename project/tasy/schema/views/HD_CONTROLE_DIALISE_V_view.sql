-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hd_controle_dialise_v (nr_sequencia, ds_cor, dt_referencia, ie_ordem, nm_usuario, nm_pessoa_fisica, ds_resultado1, ds_resultado2, ds_resultado3, ds_resultado4, ds_resultado5, ds_resultado6, ds_resultado7, ds_resultado8, ds_resultado9, ds_resultado10, ds_resultado11, ds_resultado12, ds_resultado13, ds_resultado14, ds_resultado15, ds_resultado16, ds_resultado17, ds_resultado18, ds_resultado19, ds_resultado20, ds_resultado21, ds_resultado22, ds_resultado23, ds_resultado24, ds_resultado25, ds_resultado26, ds_resultado27, ds_resultado28, ds_resultado29, ds_resultado30, ds_resultado31, ds_resultado32, ds_resultado33, ds_resultado34, ds_resultado35, ds_resultado36, ds_resultado37, ds_resultado38, ds_resultado39, ds_resultado40, ds_resultado41, ds_resultado42, ds_resultado43, ds_resultado44, ds_resultado45, ds_resultado46, ds_resultado47, ds_resultado48, ds_resultado49, ds_resultado50, ds_cor1, ds_cor2, ds_cor3, ds_cor4, ds_cor5, ds_cor6, ds_cor7, ds_cor8, ds_cor9, ds_cor10, ds_cor11, ds_cor12, ds_cor13, ds_cor14, ds_cor15, ds_cor16, ds_cor17, ds_cor18, ds_cor19, ds_cor20, ds_cor21, ds_cor22, ds_cor23, ds_cor24, ds_cor25, ds_cor26, ds_cor27, ds_cor28, ds_cor29, ds_cor30, ds_cor31, ds_cor32, ds_cor33, ds_cor34, ds_cor35, ds_cor36, ds_cor37, ds_cor38, ds_cor39, ds_cor40, ds_cor41, ds_cor42, ds_cor43, ds_cor44, ds_cor45, ds_cor46, ds_cor47, ds_cor48, ds_cor49, ds_cor50) AS select nr_sequencia,
      ds_cor,
      dt_referencia,
      ie_ordem,
      nm_usuario,
      substr(obter_nome_pf(cd_pessoa_fisica),1,255) nm_pessoa_fisica,
      substr(ds_resultado1,1,255) ds_resultado1,
      substr(ds_resultado2,1,255) ds_resultado2,
      substr(ds_resultado3,1,255) ds_resultado3,
      substr(ds_resultado4,1,255) ds_resultado4,
      substr(ds_resultado5,1,255) ds_resultado5,
      substr(ds_resultado6,1,255) ds_resultado6,
      substr(ds_resultado7,1,255) ds_resultado7,
      substr(ds_resultado8,1,255) ds_resultado8,
      substr(ds_resultado9,1,255) ds_resultado9,
      substr(ds_resultado10,1,255) ds_resultado10,
      substr(ds_resultado11,1,255) ds_resultado11,
      substr(ds_resultado12,1,255) ds_resultado12,
      substr(ds_resultado13,1,255) ds_resultado13,
      substr(ds_resultado14,1,255) ds_resultado14,
      substr(ds_resultado15,1,255) ds_resultado15,
      substr(ds_resultado16,1,255) ds_resultado16,
      substr(ds_resultado17,1,255) ds_resultado17,
      substr(ds_resultado18,1,255) ds_resultado18,
      substr(ds_resultado19,1,255) ds_resultado19,
      substr(ds_resultado20,1,255) ds_resultado20,
      substr(ds_resultado21,1,255) ds_resultado21,
      substr(ds_resultado22,1,255) ds_resultado22,
      substr(ds_resultado23,1,255) ds_resultado23,
      substr(ds_resultado24,1,255) ds_resultado24,
      substr(ds_resultado25,1,255) ds_resultado25,
      substr(ds_resultado26,1,255) ds_resultado26,
      substr(ds_resultado27,1,255) ds_resultado27,
      substr(ds_resultado28,1,255) ds_resultado28,
      substr(ds_resultado29,1,255) ds_resultado29,
      substr(ds_resultado30,1,255) ds_resultado30,
      substr(ds_resultado31,1,255) ds_resultado31,
      substr(ds_resultado32,1,255) ds_resultado32,
      substr(ds_resultado33,1,255) ds_resultado33,
      substr(ds_resultado34,1,255) ds_resultado34,
      substr(ds_resultado35,1,255) ds_resultado35,
      substr(ds_resultado36,1,255) ds_resultado36,
      substr(ds_resultado37,1,255) ds_resultado37,
      substr(ds_resultado38,1,255) ds_resultado38,
      substr(ds_resultado39,1,255) ds_resultado39,
      substr(ds_resultado40,1,255) ds_resultado40,
      substr(ds_resultado41,1,255) ds_resultado41,
      substr(ds_resultado42,1,255) ds_resultado42,
      substr(ds_resultado43,1,255) ds_resultado43,
      substr(ds_resultado44,1,255) ds_resultado44,
      substr(ds_resultado45,1,255) ds_resultado45,
      substr(ds_resultado46,1,255) ds_resultado46,
      substr(ds_resultado47,1,255) ds_resultado47,
      substr(ds_resultado48,1,255) ds_resultado48,
      substr(ds_resultado49,1,255) ds_resultado49,
      substr(ds_resultado50,1,255) ds_resultado50,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'1',nm_usuario),1,20)) ds_cor1,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'2',nm_usuario),1,20)) ds_cor2,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'3',nm_usuario),1,20)) ds_cor3,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'4',nm_usuario),1,20)) ds_cor4,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'5',nm_usuario),1,20)) ds_cor5,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'6',nm_usuario),1,20)) ds_cor6,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'7',nm_usuario),1,20)) ds_cor7,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'8',nm_usuario),1,20)) ds_cor8,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'9',nm_usuario),1,20)) ds_cor9,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'10',nm_usuario),1,20)) ds_cor10,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'11',nm_usuario),1,20)) ds_cor11,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'12',nm_usuario),1,20)) ds_cor12,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'13',nm_usuario),1,20)) ds_cor13,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'14',nm_usuario),1,20)) ds_cor14,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'15',nm_usuario),1,20)) ds_cor15,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'16',nm_usuario),1,20)) ds_cor16,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'17',nm_usuario),1,20)) ds_cor17,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'18',nm_usuario),1,20)) ds_cor18,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'19',nm_usuario),1,20)) ds_cor19,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'20',nm_usuario),1,20)) ds_cor20,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'21',nm_usuario),1,20)) ds_cor21,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'22',nm_usuario),1,20)) ds_cor22,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'23',nm_usuario),1,20)) ds_cor23,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'24',nm_usuario),1,20)) ds_cor24,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'25',nm_usuario),1,20)) ds_cor25,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'26',nm_usuario),1,20)) ds_cor26,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'27',nm_usuario),1,20)) ds_cor27,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'28',nm_usuario),1,20)) ds_cor28,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'29',nm_usuario),1,20)) ds_cor29,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'30',nm_usuario),1,20)) ds_cor30,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'31',nm_usuario),1,20)) ds_cor31,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'32',nm_usuario),1,20)) ds_cor32,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'33',nm_usuario),1,20)) ds_cor33,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'34',nm_usuario),1,20)) ds_cor34,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'35',nm_usuario),1,20)) ds_cor35,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'36',nm_usuario),1,20)) ds_cor36,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'37',nm_usuario),1,20)) ds_cor37,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'38',nm_usuario),1,20)) ds_cor38,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'39',nm_usuario),1,20)) ds_cor39,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'40',nm_usuario),1,20)) ds_cor40,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'41',nm_usuario),1,20)) ds_cor41,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'42',nm_usuario),1,20)) ds_cor42,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'43',nm_usuario),1,20)) ds_cor43,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'44',nm_usuario),1,20)) ds_cor44,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'45',nm_usuario),1,20)) ds_cor45,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'46',nm_usuario),1,20)) ds_cor46,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'47',nm_usuario),1,20)) ds_cor47,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'48',nm_usuario),1,20)) ds_cor48,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'49',nm_usuario),1,20)) ds_cor49,
  CONVERTE_COR_HEX_DELPHI(substr(HD_OBTER_COR_FORA(nr_sequencia,'50',nm_usuario),1,20)) ds_cor50
FROM   hd_grid_controle_dialise;
